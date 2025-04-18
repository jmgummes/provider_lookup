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

    let(:external_physician_base) do
      { 
        "result_count" => 1,
        "results" => [
          {
            "created_epoch" => "1400776683000",
            "enumeration_type" => "NPI-1",
            "last_updated_epoch" => "1689611552000",
            "number" => "2100000000",
            "addresses" => [
              {
                "country_code" => "US",
                "country_name" => "United States",
                "address_purpose" => "LOCATION",
                "address_type" => "DOM",
                "address_1" =>"101 NW ENGLEWOOD RD STE 110",
                "address_2" => "TEST_ADDRESS_2",
                "city" => "GLADSTONE",
                "state" => "MO",
                "postal_code" => "641184040",
                "telephone_number" => "816-413-0900",
                "fax_number" => "TEST_FAX_NUMBER"
              },
              {
                "country_code" => "US",
                "country_name" => "United States",
                "address_purpose" => "MAILING",
                "address_type" => "DOM",
                "address_1" => "712 1ST TER",
                "address_2" => "STE 103",
                "city" => "LANSING",
                "state" => "KS",
                "postal_code" => "660431735",
                "telephone_number" => "913-727-2022",
                "fax_number" => "913-727-2033"
              }
            ],
            "practiceLocations" => [],
            "basic" => {
              "name_prefix" => "TEST_NAME_PREFIX",
              "first_name" => "SHARI",
              "middle_name" => "TEST_MIDDLE_NAME",
              "last_name" => "ALBRIGHT",
              "credential" => "PTA",
              "sole_proprietor" => "NO",
              "sex" => "F",
              "enumeration_date" => "2014-05-22",
              "last_updated" => "2023-07-17",
              "certification_date" => "2023-07-17",
              "status" => "A"
            },
            "taxonomies" => [
              {
                "code" => "225200000X",
                "taxonomy_group" => "",
                "desc" => "Physical Therapy Assistant",
                "state" => "MO",
                "license" => "2014026215",
                "primary" => true
              }
            ],
            "identifiers" => [],
            "endpoints" => [],
            "other_names" => []
          }
        ]
      }
    end

    let(:external_clinic_base) do
      {
        "result_count" => 1,
        "results" => [
          {
            "created_epoch" => "1187712118000",
            "enumeration_type" => "NPI-2",
            "last_updated_epoch" => "1187712118000",
            "number" => "2100000000",
            "addresses" => [
              {
                "country_code" => "US",
                "country_name" => "United States",
                "address_purpose" => "MAILING",
                "address_type" => "DOM",
                "address_1" => "6246 N CHATHAM AVE",
                "address_2" => "TEST_ADDRESS_2",
                "city" => "KANSAS CITY",
                "state" => "MO",
                "postal_code" => "641512472",
                "telephone_number" => "816-587-6234",
                "fax_number" => "TEST_FAX_NUMBER"
              },
              {
                "country_code" => "US",
                "country_name" => "United States",
                "address_purpose" => "LOCATION",
                "address_type" => "DOM",
                "address_1" => "6246 N CHATHAM AVE",
                "address_2" => "TEST_ADDRESS_2",
                "city" => "KANSAS CITY",
                "state" => "MO",
                "postal_code" => "641512472",
                "telephone_number" => "816-587-6234",
                "fax_number" => "TEST_FAX_NUMBER"
              }
            ],
            "practiceLocations" => [],
            "basic" => {
              "organization_name" => "ADAMS PHYSICAL REHAB & SPINE CENTER, LLC",
              "organizational_subpart" => "NO",
              "enumeration_date" => "2007-08-21",
              "last_updated" => "2007-08-21",
              "status" => "A",
              "authorized_official_first_name" => "STEVE",
              "authorized_official_last_name" => "ADAMS",
              "authorized_official_telephone_number" => "8165876234",
              "authorized_official_title_or_position" => "owner/physical therapist",
              "authorized_official_name_prefix" => "Mr.",
              "authorized_official_name_suffix" => "--",
              "authorized_official_credential" => "PT"
            },
            "taxonomies" => [
              {
                "code" => "261QP2000X",
                "taxonomy_group" => "",
                "desc" => "Clinic/Center, Physical Therapy",
                "state" => "MO",
                "license" => "01748",
                "primary" => true
              }
            ],
            "identifiers" => [],
            "endpoints" => [],
            "other_names" => []
          }
        ]
      }
    end

    def check_created_physician
      physicians_count_post = Physician.count
      expect(physicians_count_post - @physicians_count_pre).to eq(1)

      physician = Physician.last
      expect(physician.number).to eq(2100000000)

      min_order = Physician.minimum(:order)
      expect(physician.order).to eq(min_order)
      expect(Physician.where(:order => min_order).count).to eq(1)

      expect(physician).to have_attributes(
        name_prefix: "TEST_NAME_PREFIX",
        first_name: "SHARI",
        last_name: "ALBRIGHT",
        middle_name: "TEST_MIDDLE_NAME",
        credential: "PTA",
        sole_proprietor: "NO",
        sex: "F",
        status: "A",
        location_address_country_code: "US",
        location_address_type: "DOM",
        location_address_1: "101 NW ENGLEWOOD RD STE 110",
        location_address_2: "TEST_ADDRESS_2",
        location_address_city: "GLADSTONE",
        location_address_state: "MO",
        location_address_postal_code: "641184040",
        location_address_telephone_number: "816-413-0900",
        location_address_fax_number: "TEST_FAX_NUMBER",
        mailing_address_country_code: "US",
        mailing_address_type: "DOM",
        mailing_address_1: "712 1ST TER",
        mailing_address_2: "STE 103",
        mailing_address_city: "LANSING",
        mailing_address_state: "KS",
        mailing_address_postal_code: "660431735",
        mailing_address_telephone_number: "913-727-2022",
        mailing_address_fax_number: "913-727-2033"
      )

      physician
    end

    def check_created_clinic
      clinics_count_post = Clinic.count
      expect(clinics_count_post - @clinics_count_pre).to eq(1)

      clinic = Clinic.last
      expect(clinic.number).to eq(2100000000)

      min_order = Clinic.minimum(:order)
      expect(clinic.order).to eq(min_order)
      expect(Clinic.where(:order => min_order).count).to eq(1)

      expect(clinic).to have_attributes(
        organization_name: "ADAMS PHYSICAL REHAB & SPINE CENTER, LLC",
        organizational_subpart: "NO",
        status: "A",
        authorized_official_first_name: "STEVE",
        authorized_official_last_name: "ADAMS",
        authorized_official_telephone_number: "8165876234",
        authorized_official_title_or_position: "owner/physical therapist",
        authorized_official_name_prefix: "Mr.",
        mailing_address_country_code: "US",
        mailing_address_type: "DOM",
        mailing_address_1: "6246 N CHATHAM AVE",
        mailing_address_2: "TEST_ADDRESS_2",
        mailing_address_city: "KANSAS CITY",
        mailing_address_state: "MO",
        mailing_address_postal_code: "641512472",
        mailing_address_telephone_number: "816-587-6234",
        mailing_address_fax_number: "TEST_FAX_NUMBER",
        location_address_country_code: "US",
        location_address_type: "DOM",
        location_address_1: "6246 N CHATHAM AVE",
        location_address_2: "TEST_ADDRESS_2",
        location_address_city: "KANSAS CITY",
        location_address_state: "MO",
        location_address_postal_code: "641512472",
        location_address_telephone_number:  "816-587-6234",
        location_address_fax_number: "TEST_FAX_NUMBER"
      )

      clinic
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
      
      context "params[:npi] does not exist internally" do
        context "params[:npi] is not found externally" do
          before do
            response_body = {
              result_count: 0,
              results: []
            }
            stub_request(:get, "https://npiregistry.cms.hhs.gov/api/?number=2100000000&version=2.1").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'npiregistry.cms.hhs.gov',
                'User-Agent'=>'Ruby'
              }).
            to_return(status: 200, body: response_body.to_json, headers: {})

            put :find, params: { npi: 2100000000 }
          end

          it "should respond with 'bad request'" do
            expect(response).to be_bad_request
          end
        end

        context "external error occurs" do
          before do
            stub_request(:get, "https://npiregistry.cms.hhs.gov/api/?number=2100000000&version=2.1").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'npiregistry.cms.hhs.gov',
                'User-Agent'=>'Ruby'
              }).
            to_return(status: 500, body: "", headers: {})

            put :find, params: { npi: 2100000000 }
          end

          it "should respond with 'error'" do
            expect(response).to have_http_status(:error)
          end
        end

        context "params[:npi] corresponds to a physician with a taxonomy NOT in the db" do
          before do
            stub_request(:get, "https://npiregistry.cms.hhs.gov/api/?number=2100000000&version=2.1").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'npiregistry.cms.hhs.gov',
                'User-Agent'=>'Ruby'
              }).
            to_return(status: 200, body: external_physician_base.to_json, headers: {})

            @physicians_count_pre = Physician.count
            @physician_taxonomies_count_pre = PhysicianTaxonomy.count
            @physician_taxonomy_edges_count_pre = PhysicianTaxonomyEdge.count

            put :find, params: { npi: 2100000000 }
          end

          it "should respond with 'ok'" do
            expect(response).to be_ok
          end

          it "should create physician with npi 2100000000 and minimum order, taxonomy and taxonomy edge" do
            physician = check_created_physician
            
            physician_taxonomies_count_post = PhysicianTaxonomy.count
            expect(physician_taxonomies_count_post - @physician_taxonomies_count_pre).to eq(1)
            physician_taxonomy = PhysicianTaxonomy.last
            expect(physician_taxonomy).to have_attributes(
              code: "225200000X",
              description: "Physical Therapy Assistant"
            )

            physician_taxonomy_edges_count_post = PhysicianTaxonomyEdge.count
            expect(physician_taxonomy_edges_count_post - @physician_taxonomy_edges_count_pre).to eq(1)
            physician_taxonomy_edge = PhysicianTaxonomyEdge.last
            expect(physician_taxonomy_edge).to  have_attributes(
              physician_id: physician.id,
              physician_taxonomy_id: physician_taxonomy.id,
              primary: true,
              state: "MO",
              license: "2014026215"
            )
          end
        end
      end

      context "params[:npi] corresponds to a physician with a taxonomy in the db" do
        before do
          response_body = external_physician_base
          response_body["results"].first["taxonomies"].first["code"] = physician_1_taxonomy.code
          stub_request(:get, "https://npiregistry.cms.hhs.gov/api/?number=2100000000&version=2.1").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'npiregistry.cms.hhs.gov',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: response_body.to_json, headers: {})

          @physicians_count_pre = Physician.count
          @physician_taxonomies_count_pre = PhysicianTaxonomy.count
          @physician_taxonomy_edges_count_pre = PhysicianTaxonomyEdge.count

          put :find, params: { npi: 2100000000 }
        end

        it "should respond with 'ok'" do
          expect(response).to be_ok
        end

        it "should create physician with npi 2100000000 and minimum order and taxonomy edge" do
          physician = check_created_physician
          
          physician_taxonomies_count_post = PhysicianTaxonomy.count
          expect(physician_taxonomies_count_post - @physician_taxonomies_count_pre).to eq(0)

          physician_taxonomy_edges_count_post = PhysicianTaxonomyEdge.count
          expect(physician_taxonomy_edges_count_post - @physician_taxonomy_edges_count_pre).to eq(1)
          physician_taxonomy_edge = PhysicianTaxonomyEdge.last
          expect(physician_taxonomy_edge).to  have_attributes(
            physician_id: physician.id,
            physician_taxonomy_id: physician_1_taxonomy.id,
            primary: true,
            state: "MO",
            license: "2014026215"
          )
        end
      end

      context "params[:npi] corresponds to a physician with a taxonomy NOT in the db, and the provider
        has two taxonomy edges to the same taxonomy" do
        before do
          response_body = external_physician_base
          response_body["results"].first["taxonomies"] << {
            "code" => "225200000X",
            "taxonomy_group" => "",
            "desc" => "Physical Therapy Assistant",
            "state" => "KS",
            "license" => "14-02702",
            "primary" => false
          }
          stub_request(:get, "https://npiregistry.cms.hhs.gov/api/?number=2100000000&version=2.1").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'npiregistry.cms.hhs.gov',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: response_body.to_json, headers: {})

          @physicians_count_pre = Physician.count
          @physician_taxonomies_count_pre = PhysicianTaxonomy.count
          @physician_taxonomy_edges_count_pre = PhysicianTaxonomyEdge.count

          put :find, params: { npi: 2100000000 }
        end

        it "should respond with 'ok'" do
          expect(response).to be_ok
        end

        it "should create physician with npi 2100000000 and minimum order, taxonomy and two taxonomy edges" do
          physician = check_created_physician
          
          physician_taxonomies_count_post = PhysicianTaxonomy.count
          expect(physician_taxonomies_count_post - @physician_taxonomies_count_pre).to eq(1)
          physician_taxonomy = PhysicianTaxonomy.last
          expect(physician_taxonomy).to have_attributes(
            code: "225200000X",
            description: "Physical Therapy Assistant"
          )

          physician_taxonomy_edges_count_post = PhysicianTaxonomyEdge.count
          expect(physician_taxonomy_edges_count_post - @physician_taxonomy_edges_count_pre).to eq(2)
          physician_taxonomy_edges = PhysicianTaxonomyEdge.last(2)
          expect(physician_taxonomy_edges).to match_array([
            have_attributes(
              physician_id: physician.id,
              physician_taxonomy_id: physician_taxonomy.id,
              primary: true,
              state: "MO",
              license: "2014026215"
            ),
            have_attributes(
              physician_id: physician.id,
              physician_taxonomy_id: physician_taxonomy.id,
              primary: false,
              state: "KS",
              license: "14-02702"
            ),
          ])
        end
      end

      context "params[:npi] corresponds to a clinic with a taxonomy NOT in the db" do
        before do
          stub_request(:get, "https://npiregistry.cms.hhs.gov/api/?number=2100000000&version=2.1").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'npiregistry.cms.hhs.gov',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: external_clinic_base.to_json, headers: {})

          @clinics_count_pre = Clinic.count
          @clinic_taxonomies_count_pre = ClinicTaxonomy.count
          @clinic_taxonomy_edges_count_pre = ClinicTaxonomyEdge.count

          put :find, params: { npi: 2100000000 }
        end

        it "should respond with 'ok'" do
          expect(response).to be_ok
        end

        it "should create clinic with npi 2100000000 and minimum order, taxonomy and taxonomy edge" do
          clinic = check_created_clinic
          
          clinic_taxonomies_count_post = ClinicTaxonomy.count
          expect(clinic_taxonomies_count_post - @clinic_taxonomies_count_pre).to eq(1)
          clinic_taxonomy = ClinicTaxonomy.last
          expect(clinic_taxonomy).to have_attributes(
            code: "261QP2000X",
            description: "Clinic/Center, Physical Therapy"
          )

          clinic_taxonomy_edges_count_post = ClinicTaxonomyEdge.count
          expect(clinic_taxonomy_edges_count_post - @clinic_taxonomy_edges_count_pre).to eq(1)
          clinic_taxonomy_edge = ClinicTaxonomyEdge.last
          expect(clinic_taxonomy_edge).to  have_attributes(
            clinic_id: clinic.id,
            clinic_taxonomy_id: clinic_taxonomy.id,
            primary: true,
            state: "MO",
            license: "01748"
          )
        end
      end

      context "params[:npi] corresponds to a clinic with a taxonomy in the db" do
        before do
          response_body = external_clinic_base
          response_body["results"].first["taxonomies"].first["code"] = clinic_1_taxonomy.code
          stub_request(:get, "https://npiregistry.cms.hhs.gov/api/?number=2100000000&version=2.1").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'npiregistry.cms.hhs.gov',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: response_body.to_json, headers: {})

          @clinics_count_pre = Clinic.count
          @clinic_taxonomies_count_pre = ClinicTaxonomy.count
          @clinic_taxonomy_edges_count_pre = ClinicTaxonomyEdge.count

          put :find, params: { npi: 2100000000 }
        end

        it "should respond with 'ok'" do
          expect(response).to be_ok
        end

        it "should create clinic with npi 2100000000 and minimum order and taxonomy edge" do
          clinic = check_created_clinic
          
          clinic_taxonomies_count_post = ClinicTaxonomy.count
          expect(clinic_taxonomies_count_post - @clinic_taxonomies_count_pre).to eq(0)

          clinic_taxonomy_edges_count_post = ClinicTaxonomyEdge.count
          expect(clinic_taxonomy_edges_count_post - @clinic_taxonomy_edges_count_pre).to eq(1)
          clinic_taxonomy_edge = ClinicTaxonomyEdge.last
          expect(clinic_taxonomy_edge).to  have_attributes(
            clinic_id: clinic.id,
            clinic_taxonomy_id: clinic_1_taxonomy.id,
            primary: true,
            state: "MO",
            license: "01748"
          )
        end
      end
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
