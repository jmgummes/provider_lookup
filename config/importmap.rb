# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.1/lib/assets/compiled/rails-ujs.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.2/lib/index.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js"
pin "jqueryui", to: "https://ga.jspm.io/npm:jqueryui@1.11.1/jquery-ui.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js"
pin "datatables.net-bs5", to: "https://ga.jspm.io/npm:datatables.net-bs5@1.11.4/js/dataTables.bootstrap5.js"
pin "datatables.net", to: "https://ga.jspm.io/npm:datatables.net@1.11.4/js/jquery.dataTables.js"
pin "jquery_setup", to: "jquery_setup.js"
pin_all_from "app/javascript/controllers", under: "controllers"
