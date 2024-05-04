## gh-dash から DiffviewOpen するコマンドの解説
まず全体像を記す。
```yaml
    - key: d
      command: |-
        /Applications/WezTerm.app/Contents/MacOS/wezterm cli spawn --cwd {{.RepoPath}} -- \
        bash -c '/Applications/WezTerm.app/Contents/MacOS/wezterm cli set-tab-title {{.RepoName}}#{{.PrNumber}} &&'\
        'gh pr checkout {{.PrNumber}} &&'\
        'nvim -c '\
        '  ":execute '"'"'DiffviewOpen origin/$(gh pr status --json baseRefName -q .currentBranch.baseRefName)...{{.HeadRefName}}'"'"\
        '   | :tabonly"' \
        > /dev/null 2>&1
```

double bracket (`{{...}}`) で囲われた変数は、YAMLパーサーがcommand文字列を解釈した後、シェルに渡す前のタイミングで展開される。説明の便宜のために以下の変数展開が行われたとする。
```
{{.RepoPath}} -> path/to/datahaikuninja/dotfiles
{{.RepoName}} -> datahaikuninja/dotfiles
{{.PrNumber}} -> 10
{{.HeadRefName}} -> feat/wezterm-cli
```

新しいWeztermのタブを作成する。`--cwd` で初期ディレクトリを指定し、`--` 以降に実行したいコマンドを指定している。`/dev/null`は`gh-dash`を終了した際に、`wezterm cli`コマンドの戻り値が`gh-dash`を実行した端末の標準出力に書き出されないようにするために実行している。
```shell
/Applications/WezTerm.app/Contents/MacOS/wezterm cli spawn --cwd path/to/datahaikuninja/dotfiles -- bash -c '...' >/dev/null 2>&1
```

`--` 以降では複数のコマンドを実行したいが、素直に `&&` でコマンドを連結すると、`&&` の右辺のコマンドが、`wezterm cli spawn` コマンドを実行したシェルで実行されてしまうので期待通り動かない。例えば、`gh-dash` をホームディレクトリで起動した場合、`gh pr checkout` がホームディレクトリで実行されてしまって .git ディレクトリが存在しない、というエラーが発生した。このエラーを回避するため、`bash -c` の引数に実行したいコマンドを文字列として渡しており、文字列内で複数のコマンドを `&&` で連結した。

以下のコマンドで、wezterm-cli spawn で立ち上げたタブ名をリネームする。
```shell
bash -c '/Applications/WezTerm.app/Contents/MacOS/wezterm cli set-tab-title datahaikuninja/dotfiles#10 &&'\
```

該当のPR(branch)にチェックアウトする。
```shell
'gh pr checkout 10 &&'\
```
以下のコマンドは一遍に説明する。`nvim -c` の引数には`":execute ... :tabonly"`が渡される。`:execute`は引数に渡された文字列をVimscriptのコマンドとして解釈するので、`DiffviewOpen`を実行して、続いて`tabonly`を実行する。
```shell
'nvim -c '\
'  ":execute '"'"'DiffviewOpen origin/$(gh pr status --json baseRefName -q .currentBranch.baseRefName)...feat/wezterm-cli'"'"\
'   | :tabonly"' \
```
`DiffviewOpen` はNeovim起動時のデフォルトのタブではなく、新しいタブで diffview を表示するのだが、個人的には2つ以上のタブが開くことで Neovim の tabline に1行分の表示領域が取られることが気になったので、`DiffviewOpen` が表示されている以外のタブを閉じるために、`DiffviewOpen` に続けて `tabonly` をパイプで繋いでいる。

ところが、tabonly を素直にパイプで繋ぐと、`tabonly` が `DiffviewOpen` のコマンド引数として解釈されてしまい期待通り動かない。回避策として、`DiffviewOpen` のコマンドを文字列として Vimscript の execute(`execute {expr}`)に渡して先に実行させ、続いて `tabonly` を実行するようにした。

一連のコマンドの意味を説明したところで、複雑なクォートとインデントの処理を説明する。
行頭のインデントはYAMLパーサーによって無視されて空白文字として解釈されることはない。

`wezterm cli spawn`を実行するシェルにより、`bash -c`に引き渡したコマンドライン文字列を連結するためのシングルクォートが取り外される。また、各行末の `\` + 改行が除去され、さらに空白を挟まずに連続した文字列は連結される。

取り外されるシングルクォートおよびダブルクォートを[]で囲む。
```shell
bash -c [']/Applications/WezTerm.app/Contents/MacOS/wezterm cli set-tab-title datahaikuninja/dotfiles#10 &&[']\
[']gh pr checkout 10 &&[']\
[']nvim -c [']\
[']  ":execute [']["]'["][']DiffviewOpen origin/$(gh pr status --json baseRefName -q .currentBranch.baseRefName)...feat/wezterm-cli[']["]'["]\
[']   | :tabonly"['] \
```

クォートの取り外し、行連結および文字列連結の結果、以下の文字列が`bash -c`に渡される。
```shell
/Applications/WezTerm.app/Contents/MacOS/wezterm cli set-tab-title datahaikuninja/dotfiles#10 &&gh pr checkout 10 &&nvim -c   ":execute 'DiffviewOpen origin/$(gh pr status --json baseRefName -q .currentBranch.baseRefName)...feat/wezterm-cli'   | :tabonly"
```

`DiffviewOpen`の直前の`'`から、`feat/wezterm-cli`の直後の`'` までの部分は最終的に Vimscript の文字列リテラルとして解釈され、`:execute` コマンドに対する引数として渡される。

```shell
:execute 'DiffviewOpen origin/$(gh pr status --json baseRefName -q .currentBranch.baseRefName)...feat/wezterm-cli'
```
