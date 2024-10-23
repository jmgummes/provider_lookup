import { Controller } from "@hotwired/stimulus";

import "../jquery_setup"
import "jqueryui"
import DataTable from "datatables.net-bs5";
window.DataTable = DataTable();

export default class extends Controller {

  static targets = [
    "searchForm", "searchField", "physiciansTab", "clinicsTab", 
    "physiciansDiv", "clinicsDiv", "physiciansTable", "clinicsTable" 
  ];

  connect() {
    this.connectSearchError();
    this.connectSearchSuccess();
    this.connectTab(this.physiciansTabTarget, this.physiciansDivTarget);
    this.connectTab(this.clinicsTabTarget, this.clinicsDivTarget);
    this.physiciansTableObject = this.connectTable(this.physiciansTableTarget, "physicians");
    this.clinicsTableObject = this.connectTable(this.clinicsTableTarget, "clinics");
  }
  
  connectSearchError() {
    this.searchFormTarget.addEventListener("ajax:error", (event) =>
      this.handleError(event)
    );  
  }
  
  connectSearchSuccess() {
    this.searchFormTarget.addEventListener("ajax:success", (event) =>
      this.handleSuccess(event)
    );
  }
  
  connectTab(tab, div) {
    $(tab).click(this.tabListener(event, tab, div, this));
  }
  
  connectTable(table, action) {
    return $(table).DataTable({
      serverSide: true,
      ajax: "/providers/" + action,
      searching: false,
      ordering: false
    });
  }
  
  tabListener(event, tab, div, controller) {
    return (event) => {
      event.preventDefault();
      controller.activateTab(tab, div);
    }
  }
  
  handleError(event) {
    let error = event.detail[0].error;
    alert(error === undefined ? "Something went wrong." : "Error: " + event.detail[0].error);
  }
  
  handleSuccess(event) {
    if(event.detail[0].provider_type == "physician")
      this.showUpdatedProviders(this.physiciansTabTarget, this.physiciansDivTarget, this.physiciansTableObject);
    else
      this.showUpdatedProviders(this.clinicsTabTarget, this.clinicsDivTarget, this.clinicsTableObject);
  }
  
  showUpdatedProviders(tab, div, table) {
    $(this.searchFieldTarget).val("");
    this.activateTab(tab, div);    
    this.addHighlightingListener(div, table);
    table.draw();
  }
  
  addHighlightingListener(div, table) {
    table.on("draw", () => {
      $(div).find("tbody > tr").first().effect("highlight", {}, 3000);
      table.off("draw");
    });
  }
  
  activateTab(tab, div) {
    $("a.nav-link").removeClass("active");
    $(tab).addClass("active");
    $("div.providers-table").hide();
    $(div).show();
  }
};
