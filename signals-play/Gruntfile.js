module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "app.js": ["Signals.elm"]
        }
      }
    },
    watch: {
      elm: {
        files: ["Signals.elm"],
        tasks: ["elm"]
      }
    },
    clean: ["elm-stuff/build-artifacts"]
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-elm');

  grunt.registerTask('default', ['elm']);

};
