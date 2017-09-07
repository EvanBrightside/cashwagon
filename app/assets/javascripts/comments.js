Vue.http.interceptors.push({
  request: function (request) {
    Vue.http.headers.common['X-CSRF-Token'] = $('[name="csrf-token"]').attr('content');
    return request;
  },
  response: function (response) {
    return response;
  }
});

var commentResource = Vue.resource('/comments{/id}.json')

Vue.component('comment-row', {
  template: '#comment-row',
  props: {
    comment: Object
  },
  data: function () {
    return {
      editMode: false,
      errors: {}
    }
  },
  methods: {
    updateComment: function () {
      var that = this;
      commentResource.update({id: that.comment.id}, {comment: that.comment}).then(
        function(response) {
          that.errors = {}
          that.comment = response.data
          that.editMode = false
        },
        function(response) {
          that.errors = response.data.errors
        }
      )
    }
  }
})

var comments = new Vue({
  el: '#comments',
  data: {
    comments: [],
    comment: {
      body: ''
    },
    errors: {}
  },
  ready: function() {
    var that;
    that = this;
    commentResource.get().then(
      function (response) {
        that.comments = response.data
      }
    )
  },
  methods: {
    leaveComment: function () {
      var that = this;
      commentResource.save({comment: this.comment}).then(
        function(response) {
          that.errors = {};
          that.comment = {};
          that.comments.push(response.data);
        },
        function(response) {
          that.errors = response.data.errors
        }
      )
    }
  }
});
