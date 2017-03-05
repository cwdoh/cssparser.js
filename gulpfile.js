var fileinclude = require('gulp-file-include'),
  gulp = require('gulp');

gulp.task('merge-js', function() {
  gulp.src([
      './src/template/node.js'
    ])
    .pipe(fileinclude({
      prefix: '@@',
      basepath: '@file'
    }))
    .pipe(gulp.dest('./dist/js'));
});

gulp.task('merge-jison', function() {
  gulp.src([
      './src/template/css.l',
      './src/template/cssparser.y'
    ])
    .pipe(fileinclude({
      prefix: '@@',
      basepath: '@file'
    }))
    .pipe(gulp.dest('./dist/jison'));
});
