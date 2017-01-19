/* jshint strict: false */
/* jshint node: true */

var autoprefixer = require('gulp-autoprefixer');
var babel        = require('babelify');
var browserify   = require('browserify');
var browserSync  = require('browser-sync').create();
var buffer       = require('vinyl-buffer');
var gulp         = require('gulp');
var notify       = require('gulp-notify');
var sass         = require('gulp-sass');
var source       = require('vinyl-source-stream');
var sourcemaps   = require('gulp-sourcemaps');
var watchify     = require('watchify');
var argv         = require('yargs').argv;

function compile(watch) {
  var bundler = watchify(browserify('./app/public/js/lib/main.js', {debug: true})
                         .transform(babel));

  function rebundle() {
    bundler.bundle()
    .on('error', function(err) { console.error(err); this.emit('end'); })
    .pipe(source('bundle.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./app/public/js'));
  }

  if (watch) {
    bundler.on('update', function() {
      console.log('-> bundling...');
      rebundle();
    });
  }

  rebundle();
}

function watch() {
  return compile(true);
}

gulp.task('jsBuild', function() { return compile(); });
gulp.task('jsWatch', function() { return watch(); });

gulp.task('browser-sync', function() {
  browserSync.init({
    proxy: 'localhost:' + (argv.proxyPort ? argv.proxyPort : '9292'),
    files: ["app/public/js/*.js"]
  });

  gulp.watch('./app/public/scss/**/*.scss', ['sass']);
});

gulp.task('sass', function() {
  gulp.src('./app/public/scss/**/*.scss')
  .pipe(sass().on('error', notify.onError({
    title: 'Error',
    message: '<%= error.message %>' 
  })))
  .pipe(autoprefixer({
    browsers: ['> 1%', 'last 2 versions', 'Android 4'],
    cascade: false
  }))
  .pipe(gulp.dest('app/public/css/'))
  .pipe(browserSync.stream());
});

gulp.task('default', ['browser-sync', 'jsWatch']);
