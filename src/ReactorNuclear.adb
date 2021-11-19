package body ReactorNuclear is

   protected body Reactor_t is

      procedure vivir1(valor: in Integer) is
      begin
         vivo1:=valor;
      end vivir1;

      entry estoyVivo1 when vivo1=1 is
      begin
         vivo1:=0;
      end estoyVivo1;

      procedure vivir2(valor: in Integer) is
      begin
         vivo2:=valor;
      end vivir2;

      entry estoyVivo2 when vivo2=1 is
      begin
         vivo2:=0;
      end estoyVivo2;

      procedure vivir3(valor: in Integer) is
      begin
         vivo3:=valor;
      end vivir3;

      entry estoyVivo3 when vivo3=1 is
      begin
         vivo3:=0;
      end estoyVivo3;

      procedure setOperation(operation:in Integer) is
      begin
            Set_Handler(TimeoutEvent, tiTimeout, Timeout'Access);
            operation_mode := operation;

            case operation_mode is
               when -1 =>
               Put_Line("ABRO COMPUERTA(>1500 && <1750) "&Integer'Image(id));
               Set_Handler(OutputEvent, tNextTime, Timer'Access);
               when 0 =>
               Put_Line("CIERRO COMPUERTA "&Integer'Image(id));
               Set_Handler(OutputEvent, tNextTime, null);
               when 1 =>
               Put_Line("ABRO COMPUERTA(>1750) "&Integer'Image(id));
               Set_Handler(OutputEvent, tNextTime, Timer'Access);
               when others =>
                  null;
            end case;

           -- delay 0.1;

           tNextTime := Clock + tiEventPeriod;
            --Set_Handler(OutputEvent, tNextTime, Timer'Access);
        -- end if;
      end setOperation;

      procedure Timer(event:in out Timing_Event) is  --hay que reducir la temperatura
      begin
         -- Put_Line("Entro en TIMER");
         if(output >=1500) then
          output:= output-50;
            Put_Line("Temperatura es "&Integer'Image(output)&"   Reactor: "&Integer'Image(id));
         end if;

         tNextTime := Clock + tiEventPeriod;
         Set_Handler(OutputEvent, tiEventPeriod, Timer'Access);
      exception
            when Constraint_Error => null; --no existe cuando es llamado, se ha parado
      end Timer;

      function getOutput return Output_t is
      begin
         return output;
      end getOutput;

      procedure setID(newID:in Integer) is
      begin
        id := newID;
      end;

      procedure Timeout(event:in out Timing_Event) is
      begin
         Put_Line("Alerta: Funcionamiento incorrecto");
         Set_Handler(TimeoutEvent, tiTimeout, Timeout'Access);
      end Timeout;
      procedure setOutput(valor:in Integer) is
      begin
         output:=valor;
      end setOutput;


   end Reactor_t;

end ReactorNuclear;
