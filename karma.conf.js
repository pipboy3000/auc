// Karma configuration
// Generated on Fri May 29 2015 15:33:35 GMT+0900 (JST)

module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['mocha', 'browserify'],
    files: [
      'test/*.js'
    ],
    exclude: [
    ],
    preprocessors: {
      'test/*.js': 'browserify'
    },
    browserify: {
      debug: true,
      files: [
        'test/*.js'
      ],
      transform: [
        ['babelify', {plugins: ['babel-plugin-espower']}]
      ]
    },
    reporters: ['mocha'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['PhantomJS'],
    singleRun: false
  });
};
