var fileinclude = require('gulp-file-include'),
  gulp = require('gulp');

gulp.task('merge', function() {
  gulp.src([
      './src/template/css.l',
      './src/template/cssparser.y'
    ])
    .pipe(fileinclude({
      prefix: '@@',
      basepath: '@file'
    }))
    .pipe(gulp.dest('./dist/'));
});
