var gulp = require('gulp');
var browserSync = require('browser-sync').create();

gulp.task('watch', () => {
  browserSync.init({
    server: {
      baseDir: './site'
    }
  });

  gulp.watch('./site/**/*', browserSync.reload);
});
