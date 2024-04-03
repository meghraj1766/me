class apb_driver extends uvm_driver#(apb_pkt);

	`uvm_component_utils(apb_driver)
////
	////dude ji
	apb_pkt p;

	virtual intf vif;

	function new(string name, uvm_component parent);

		super.new(name, parent);

	endfunction

	virtual function void build_phase (uvm_phase phase);
      		
		if (! uvm_config_db #(virtual intf) :: get (this, "", "vif", vif)) begin
         		
			`uvm_fatal (get_type_name (), "Didn't get handle to virtual interface intf")
      		
		end
        
	endfunction

	task run_phase(uvm_phase phase);

		p=apb_pkt::type_id::create("p");
		forever begin
			wait (this.vif.PRESETn);
		//	@(this.vif.dri_cb);
			seq_item_port.get_next_item(p);
			@(this.vif.dri_cb);
			$display("---------APB Driver-----------");
			p.print();
    			this.vif.dri_cb.PENABLE <= 0;
			case(p.PWRITE)

				0   :  read(p.PADDR, p.PRDATA);
				1   :  write(p.PADDR, p.PWDATA);
			
			endcase

			seq_item_port.item_done();

		end

	endtask

	virtual task read(input  bit   [31:0] ADDR, output logic [31:0] DATA);
    
	      //  wait(this.vif.dri_cb.PREADY);
			this.vif.dri_cb.PADDR   <= ADDR;
    			this.vif.dri_cb.PWRITE  <= 0;
    			this.vif.dri_cb.PSELn   <= 1;
    		@ (this.vif.dri_cb);
    			this.vif.dri_cb.PENABLE <= 1;
			if(!this.vif.PREADY) begin
				wait (this.vif.PREADY);
				@(this.vif.dri_cb);
			end
    		//@ (this.vif.dri_cb); 
			DATA = this.vif.PRDATA;
    		//	this.vif.dri_cb.PENABLE <= 0;

 	endtask

 	virtual task write(input bit [31:0] ADDR, input bit [31:0] DATA);
    
	//	wait(this.vif.dri_cb.PREADY);
			this.vif.dri_cb.PADDR   <= ADDR;
    			this.vif.dri_cb.PWDATA  <= DATA;
    			this.vif.dri_cb.PWRITE  <= 1;
    			this.vif.dri_cb.PSELn   <= 1;
   		@ (this.vif.dri_cb);
    			this.vif.dri_cb.PENABLE <= 1;
			if(!this.vif.PREADY) begin
				wait (this.vif.PREADY);
				@(this.vif.dri_cb);
			end
    		//@ (this.vif.dri_cb);
    			//this.vif.dri_cb.PENABLE <= 0;
  	///////Meghraj//////
	endtask
//////
	////
endclass

