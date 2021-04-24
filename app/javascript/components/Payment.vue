<template>
  <div>
    <form>
      <div class="card-details p-4">
        <div class="form-row">
          <div class="form-group col-md-6">
            <label class="text-capitalize">card number <span class="text-primary">*</span> </label>
            <the-mask mask="#### #### #### ####" v-model.trim="paymentDetails.cardNumber" placeholder="#### #### #### ####" class="form-control" :class="errors.cardNumber && 'is-invalid'" />
          </div>
          <div class="form-group col-md-6">
            <label class="text-uppercase">cvc <span class="text-primary">*</span></label>
            <the-mask mask="###" v-model.trim="paymentDetails.securityCode" placeholder="###" class="form-control" :class="errors.securityCode && 'is-invalid'" />
          </div>
        </div>
        <div class="form-row">
          <div class="form-group col-md-6">
            <label class="text-capitalize">cardholder name <span class="text-primary">*</span></label>
            <input type="text" v-model.trim="paymentDetails.nameOnCard" class="form-control" :class="errors.nameOnCard && 'is-invalid'">
          </div>
          <div class="form-group col-md-6">
            <label class="text-capitalize">expiration <span class="text-primary">*</span></label>
            <the-mask mask="##/##" v-model.trim="paymentDetails.expiryDate" placeholder="MM/YY" class="form-control" :class="errors.expiryDate && 'is-invalid'" />
          </div>
        </div>
      </div>
      <div class="extra-details mt-4 p-4">
        <div class="form-group">
          <label class="text-capitalize">email address <span class="text-primary">*</span></label>
          <input type="email" v-model.trim="paymentDetails.emailAddress" class="form-control" :class="errors.emailAddress && 'is-invalid'">
        </div>
        <div class="form-group">
          <label class="text-capitalize">billing address <span class="text-primary">*</span></label>
          <input type="text" v-model.trim="paymentDetails.billingAddress" class="form-control" :class="errors.billingAddress && 'is-invalid'">
        </div>
        <div class="form-group">
          <label class="text-capitalize">description</label>
          <textarea cols="30" rows="5" v-model.trim="paymentDetails.description" class="form-control" ></textarea>
        </div>
      </div>
      <p class="text-center">
        <button type="button" class="btn btn-primary px-5 btn-lg" @click="pay" :disabled="processing">{{ processing ? "Processing" : "Pay" }}</button>
      </p>
    </form>
    <modal :show="processing" :errorMessage="errorMessage" @modalClosed="onModalClosed" />
  </div>
</template>

<script>
import axios from 'axios'
import {TheMask} from 'vue-the-mask'
import { snakeCase } from "snake-case"
import Modal from './Modal'

export default {
  props: {
    pay_url: {
      type: String,
      required: true
    }
  },
  data: function () {
    return {
      processing: false,
      paymentDetails: {
        cardNumber: null,
        securityCode: null,
        nameOnCard: "",
        expiryDate: "",
        emailAddress: "",
        billingAddress: "",
        description: ""
      },
      errorMessage: "",
      errors: {}
    }
  },
  watch: {
    paymentDetails: {
      handler: function (newVal) {
        let vm = this
        // card number
        if (newVal.cardNumber && newVal.cardNumber.length === 16) {
          vm.errors.cardNumber = ""
        }
        // cvc
        if (newVal.securityCode && newVal.securityCode.length === 3) {
          vm.errors.securityCode = ""
        }
        // name on card
        if (newVal.nameOnCard && newVal.nameOnCard.length > 0) {
          vm.errors.nameOnCard = ""
        }
        // expiry date
        if (newVal.expiryDate && vm.checkExpiry(newVal.expiryDate)) {
          vm.errors.expiryDate = ""
        }
        // email address
        if (newVal.emailAddress && vm.checkEmail(newVal.emailAddress)) {
          vm.errors.emailAddress = ""
        }
        if (newVal.billingAddress && newVal.billingAddress.length > 0) {
          vm.errors.billingAddress = ""
        }
      },
      deep: true
    }
  },
  methods: {
    onModalClosed: function () {
      this.processing = false
      this.errorMessage = ""
    },
    checkExpiry: function (val) {
      if (!val || val.length !== 4) {
        return false
      }
      let d = new Date()
      let currentYear = parseInt(d.getFullYear().toString().slice(-2))
      let currentMonth = d.getMonth()
      let month = parseInt(val.slice(0, 2))
      let year = parseInt(val.slice(-2))
      // same year check
      if ((year === currentYear) && ((month - 1) > currentMonth) && (month < 13)) {
        return true
      }
      // future year
      if ((year > currentYear) && (month < 13)) {
        return true
      }
      return false
    },
    checkEmail: function (val) {
      const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(val)
    },
    validate: function () {
      let vm = this
      let obj = vm.paymentDetails
      Object.keys(obj).map(key => {
        switch (key) {
          case 'cardNumber':
            if (!obj[key] || obj[key].length !== 16) {
              vm.errors[key] = "Invalid"
            } else {
              vm.errors[key] = ""
            }
            break
          case 'securityCode':
            if (!obj[key] || obj[key].length !== 3) {
              vm.errors[key] = "Invalid"
            } else {
              vm.errors[key] = ""
            }
            break
          case 'nameOnCard':
          case 'billingAddress':
            if (!obj[key] || obj[key].length <= 0) {
              vm.errors[key] = "Invalid"
            } else {
              vm.errors[key] = ""
            }
            break
          case 'expiryDate':
            if (!vm.checkExpiry(obj[key])) {
              vm.errors[key] = "Invalid"
            } else {
              vm.errors[key] = ""
            }
            break
          case 'emailAddress':
            if (!vm.checkEmail(obj[key])) {
              vm.errors[key] = "Invalid"
            } else {
              vm.errors[key] = ""
            }
            break
        }
      })
    },
    pay: function () {
      let vm = this
      // validate first
      vm.validate()
      vm.$forceUpdate()
      let invalid = Object.keys(vm.errors).some(key => vm.errors[key])
      if (invalid) {
        return
      }
      // submit
      let formData = new FormData()
      Object.keys(vm.paymentDetails).map(key => {
        formData.append(snakeCase(key), vm.paymentDetails[key])
      })
      vm.processing = true
      axios.post(vm.pay_url, formData).then(res => {
        setTimeout(function () {
          console.log(res.data)
          vm.processing = false
          window.location.href = res.data
        }, 1000)
      }).catch(err => {
        setTimeout(function () {
          console.log(err.response.data)
          vm.errorMessage = err.response.data
        }, 1000)
      })
    }
  },
  components: {
    TheMask,
    Modal
  },
  mounted: function () {
    let token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    axios.defaults.headers.common['X-CSRF-Token'] = token
    axios.defaults.headers.common['Accept'] = 'application/json'
  }
}
</script>
<style lang="scss" scoped>
.card-details {
  border: 1px solid gray;
  border-radius: 1rem;
}
</style>