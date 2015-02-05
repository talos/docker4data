/* globals module */
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      build: {
        src: 'site/js/<%= pkg.name %>.js',
        dest: 'site/js/<%= pkg.name %>.min.js'
      }
    },
    copy: {
      all: {
        files: [{
          expand: true,
          src: ['bower_components/bootstrap/dist/fonts/*'],
          dest: 'site/fonts/',
          flatten: true
        }]
      }
    },
    bower_concat: {
      all: {
        dest: 'site/js/libs.js',
        cssDest: 'site/css/docker4data.css',
        exclude: [
          //'jquery',
          //'modernizr'
        ],
        bowerOptions: {
          relative: false
        },
        mainFiles: {
          'bootstrap-table': [
            "src/bootstrap-table.css",
            "src/bootstrap-table.js",
            "src/locale/bootstrap-table-en-US.js"
          ]
        }
      }
    },
    concat: {
      all: {
        src: ['src/*.js'],
        dest: 'site/js/docker4data.js'
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-bower-concat');

  // Default task(s).
  //grunt.registerTask('default', ['uglify']);

  grunt.registerTask('default', ['bower_concat', 'concat', 'copy']);
};
