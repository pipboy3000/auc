/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package.json>',
    meta: {
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
    },
    lint: {
      files: ['grunt.js', 'public/js/vendor/**/.js', 'public/js/lib/**/*.js']
    },
    qunit: {
      files: ['spec/**/*.html']
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>',
              'public/js/vendor/jquery-1.8.0.min.js',
              'public/js/vendor/jquery.cookie.js',
              'public/js/vendor/jquery.mustache.js',
              'public/js/vendor/jquery.miniColors.min.js',
              'public/js/vendor/bootstrap.min.js',
              'public/js/lib/**/*.js',
              'public/js/main.js'],
        dest: 'public/js/<%= pkg.name %>.js'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'public/js/<%= pkg.name %>.min.js'
      }
    },
    coffee: {
      app: {
        src: ['public/js/lib/web.coffee'],
        dest: 'public/js/main.js'
      }
    },
    sass: {
      app: {
        files: {
          'public/css/auc.css': ['public/scss/bootstrap.scss', 'public/scss/web.scss', 'public/scss/jquery.miniColors.scss']
        }
      }
    },
    reload: {
      port: 35729,
      proxy: {
        host: 'auc.dev'
      },
      liveReload: true
    },
    watch: {
      js: {
        files: ['./public/js/lib/**/*.coffee', '<config:lint.files>'],
        tasks: 'coffee lint concat min sass'
      },
      sass: {
        files: 'public/scss/**/*.scss',
        tasks: 'sass'
      },
      livereload: {
        files: ['./public/css/**/*.css', './public/js/**/*.js', './views/*.haml'],
        tasks: 'reload'
      }
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        boss: true,
        eqnull: true,
        browser: true
      },
      globals: {
        jQuery: true
      }
    },
    uglify: {}
  });

  grunt.loadNpmTasks('grunt-contrib');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-reload');

  // Default task.
  grunt.registerTask('default', 'coffee lint concat min');

};
