<template>
  <div class="modal fade" :id="uid" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-body text-center">
          <div v-if="!errorMessage" class="spinner-border text-primary" role="status">
            <span class="sr-only">Loading...</span>
          </div>
          <div v-else class="alert alert-danger" role="alert">
            {{ errorMessage }}
          </div>
        </div>
        <div class="modal-footer" v-if="errorMessage">
          <button type="button" class="btn btn-secondary" data-dismiss="modal" @click="closeModal">Close</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    errorMessage: {
      type: String,
      default: ""
    },
    show: {
      type: Boolean,
      default: false
    },
  },
  data: function () {
    return {
      uid: `modal-${this._uid}`
    }
  },
  watch: {
    show: function () {
      let vm = this
      vm.$nextTick(() => {
        if (vm.show) {
          vm.showModal()
        } else {
          vm.closeModal()
        }
      })
    }
  },
  methods: {
    init: function () {
      let vm = this;
      vm.$nextTick(() => {
        $(`#${vm.uid}`).modal({
          backdrop: "static",
          keyboard: false,
          show: vm.show
        })
      })
    },
    closeModal: function () {
      $(`#${this.uid}`).modal('hide');
      this.$emit('modalClosed');
    },
    showModal: function () {
      $(`#${this.uid}`).modal('show');
    }
  },
  mounted: function () {
    this.init()
  }
}
</script>