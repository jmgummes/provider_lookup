require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do
  context "Two physicians, two clinics, two physician_taxonomy_edges, two clinic_taxonomy_edges, two physician_taxonomies
    and two clinic_taxonomies exist in the database. The edges map taxonomies with physicians and clinics distinctly." do
    
    let!(:physician_1) { FactoryBot.create(:physician, order: 1) }
    let!(:physician_1_taxonomy) { FactoryBot.create(:physician_taxonomy) }
    let!(:physician_1_taxonomy_edge) do
      FactoryBot.create(:physician_taxonomy_edge, physician: physician_1, physician_taxonomy: physician_1_taxonomy)
    end
    
    let!(:physician_2) { FactoryBot.create(:physician, order: 2) }
    let!(:physician_2_taxonomy) { FactoryBot.create(:physician_taxonomy) }
    let!(:physician_2_taxonomy_edge) do
      FactoryBot.create(:physician_taxonomy_edge, physician: physician_2, physician_taxonomy: physician_2_taxonomy)
    end
    
    let!(:clinic_1) { FactoryBot.create(:clinic, order: 1) }
    let!(:clinic_1_taxonomy) { FactoryBot.create(:clinic_taxonomy) }
    let!(:clinic_1_taxonomy_edge) do
      FactoryBot.create(:clinic_taxonomy_edge, clinic: clinic_1, clinic_taxonomy: clinic_1_taxonomy )
    end
    
    let!(:clinic_2) { FactoryBot.create(:clinic, order: 2) }
    let!(:clinic_2_taxonomy) { FactoryBot.create(:clinic_taxonomy) }
    let!(:clinic_2_taxonomy_edge) do
      FactoryBot.create(:clinic_taxonomy_edge, clinic: clinic_2, clinic_taxonomy: clinic_2_taxonomy )
    end

    describe "#find" do
      context "params[:npi] is missing" do
        before { put :find }
        
        it "should respond with 'bad request'" do
          expect(response).to be_bad_request
        end
      end

      context "#params[:npi] is 9 digits" do
        before {  put :find, params: { npi: "123456789" } }
      
        it "should respond with 'bad request'" do
          expect(response).to be_bad_request
        end
      end
  
      context "#params[:npi] starts with 0" do
        before { put :find, params: { npi: "0123456789" } }
      
        it "should respond with 'bad request'" do          
          expect(response).to be_bad_request
        end
      end

      context "#params[:npi] contains a non-digit" do
        before { put :find, params: { npi: "123456789X" } }
      
        it "should respond with 'bad request'" do
          expect(response).to be_bad_request
        end
      end
   
      context "#params[:npi] points to physician_2" do
        before { put :find, params: { npi: physician_2.number } }
      
        it "should change the order fields on physicians such that physician_1.order > physician_2.order" do
          expect(physician_1.reload.order > physician_2.reload.order)
        end
        
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json having provider_type = 'physician'" do
          expect(JSON(response.body)["provider_type"]).to eq("physician")
        end
      end
      
      context "#params[:npi] points to clinic_2" do
        before { put :find, params: { npi: clinic_2.number } }
      
        it "should change the order fields on clinics such that clinic_1.order > clinic_2.order" do
          expect(JSON(response.body)).to be_a(Hash)
          expect(clinic_1.reload.order > clinic_2.reload.order)
        end
        
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json having provider_type = 'clinic'" do
          expect(JSON(response.body)).to be_a(Hash)
          expect(JSON(response.body)["provider_type"]).to eq("clinic")
        end
      end
      
      # TODO: add test cases for properly formed npis that are not in the database
      # -when the npi is not found externally
      # -when an external error occurs
      # -when the provider is a physician with a taxonomy NOT in the db
      # -when the provider is a physician with a taxonomy in the db
      # -when the provider is a physician with a duplicated taxonomy NOT in the db
      # -when the provider is a clinic with a taxonomy NOT in the db
      # -when the provider is a clinic with a taxonomy in the db
      # -when the provider is a clinic with a duplicated taxonomy NOT in the db
    end
    
    describe "#physicians" do
      context "params[:draw] is 1, params[:start] is 0 and params[:length] is 1" do
        before { get :physicians, params: {draw: 1, start: 0, length: 1} }
      
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json object" do
          expect(JSON(response.body)).to be_a(Hash)
        end     
        
        it "should respond with json having draw = 1" do
          expect(JSON(response.body)["draw"]).to eq(1)
        end
      
        it "should respond with json having recordsTotal = 2" do
          expect(JSON(response.body)["recordsTotal"]).to eq(2)
        end
        
        it "should respond with json having recordsFiltered = 2" do
          expect(JSON(response.body)["recordsFiltered"]).to eq(2)
        end
        
        it "should respond with json having data array with 1 element" do
          expect(JSON(response.body)["data"]).to be_a(Array)
          expect(JSON(response.body)["data"].length).to eq(1)
        end
      end
      
      context "params[:draw] is 1, params[:start] is 0 and params[:length] is 2" do
        before { get :physicians, params: {draw: 1, start: 0, length: 2} }
      
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json object" do
          expect(JSON(response.body)).to be_a(Hash)
        end     
        
        it "should respond with json having draw = 1" do
          expect(JSON(response.body)["draw"]).to eq(1)
        end
      
        it "should respond with json having recordsTotal = 2" do
          expect(JSON(response.body)["recordsTotal"]).to eq(2)
        end
        
        it "should respond with json having recordsFiltered = 2" do
          expect(JSON(response.body)["recordsFiltered"]).to eq(2)
        end
        
        it "should respond with json having data array with 2 elements" do
          expect(JSON(response.body)["data"]).to be_a(Array)
          expect(JSON(response.body)["data"].length).to eq(2)
        end
      end
      
      context "params[:draw] is 1, params[:start] is 1 and params[:length] is 2" do
        before { get :physicians, params: {draw: 1, start: 1, length: 2} }
      
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json object" do
          expect(JSON(response.body)).to be_a(Hash)
        end     
        
        it "should respond with json having draw = 1" do
          expect(JSON(response.body)["draw"]).to eq(1)
        end
      
        it "should respond with json having recordsTotal = 2" do
          expect(JSON(response.body)["recordsTotal"]).to eq(2)
        end
        
        it "should respond with json having recordsFiltered = 2" do
          expect(JSON(response.body)["recordsFiltered"]).to eq(2)
        end
        
        it "should respond with json having data array with 1 element" do
          expect(JSON(response.body)["data"]).to be_a(Array)
          expect(JSON(response.body)["data"].length).to eq(1)
        end
      end
    end
    
    describe "#clinics" do
      context "params[:draw] is 1, params[:start] is 0 and params[:length] is 1" do
        before { get :clinics, params: {draw: 1, start: 0, length: 1} }
      
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json object" do
          expect(JSON(response.body)).to be_a(Hash)
        end     
        
        it "should respond with json having draw = 1" do
          expect(JSON(response.body)["draw"]).to eq(1)
        end
      
        it "should respond with json having recordsTotal = 2" do
          expect(JSON(response.body)["recordsTotal"]).to eq(2)
        end
        
        it "should respond with json having recordsFiltered = 2" do
          expect(JSON(response.body)["recordsFiltered"]).to eq(2)
        end
        
        it "should respond with json having data array with 1 element" do
          expect(JSON(response.body)["data"]).to be_a(Array)
          expect(JSON(response.body)["data"].length).to eq(1)
        end
      end
      
      describe "params[:draw] is 1, params[:start] is 0 and params[:length] is 2" do
        before { get :clinics, params: {draw: 1, start: 0, length: 2} }
      
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json object" do
          expect(JSON(response.body)).to be_a(Hash)
        end     
        
        it "should respond with json having draw = 1" do
          expect(JSON(response.body)["draw"]).to eq(1)
        end
      
        it "should respond with json having recordsTotal = 2" do
          expect(JSON(response.body)["recordsTotal"]).to eq(2)
        end
        
        it "should respond with json having recordsFiltered = 2" do
          expect(JSON(response.body)["recordsFiltered"]).to eq(2)
        end
        
        it "should respond with json having data array with 2 elements" do
          expect(JSON(response.body)["data"]).to be_a(Array)
          expect(JSON(response.body)["data"].length).to eq(2)
        end
      end
      
      describe "params[:draw] is 1, params[:start] is 1 and params[:length] is 2" do
        before { get :clinics, params: {draw: 1, start: 1, length: 2} }
      
        it "should respond with 'ok'" do
          expect(response).to be_ok
        end
        
        it "should respond with json object" do
          expect(JSON(response.body)).to be_a(Hash)
        end     
        
        it "should respond with json having draw = 1" do
          expect(JSON(response.body)["draw"]).to eq(1)
        end
      
        it "should respond with json having recordsTotal = 2" do
          expect(JSON(response.body)["recordsTotal"]).to eq(2)
        end
        
        it "should respond with json having recordsFiltered = 2" do
          expect(JSON(response.body)["recordsFiltered"]).to eq(2)
        end
        
        it "should respond with json having data array with 1 element" do
          expect(JSON(response.body)["data"]).to be_a(Array)
          expect(JSON(response.body)["data"].length).to eq(1)
        end
      end
    end
  end
end
