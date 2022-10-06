import 'dart:io';

void main() {
  Process.run('grep', ['-i', 'version', 'pubspec.yaml']).then((grep) {
    final regex = RegExp(r'(?<match>\d+\.\d+\.\d+)');
    final match = regex.firstMatch(grep.stdout);
    final version = match!.namedGroup('match');

    Process.run('git', ['add', '.']).then((add) {
      Process.run('git', ['commit', '-m', 'Release $version']).then((commit) {
        Process.run('git', ['tag', '-a', 'v$version', '-m', 'Release $version'])
            .then((tag) {
          stderr.write(tag.stderr);
        });

        stderr.write(commit.stderr);
      });

      stderr.write(add.stderr);
    });

    stderr.write(grep.stderr);
  });
}
