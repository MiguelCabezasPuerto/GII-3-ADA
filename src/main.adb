with ReactorNuclear;
with Ada.Real_Time;
with Ada.Text_IO;

use Ada.Real_Time;
use Ada.Text_IO;


use ReactorNuclear;
with Ada.Numerics.Discrete_Random;


procedure Main is

   subtype aleatorioReactor is Integer range 1..3;
   package RNG is new Ada.Numerics.Discrete_Random(aleatorioReactor);

   subtype TemperaturaReactor_t is Integer range 0..3000;
   subtype PlantOutput_t is Integer range 0..3000;

   plant1: aliased Reactor_t;
   plant2: aliased Reactor_t;
   plant3: aliased Reactor_t;

   task type tskVariacionTemperatura; --tarea que cada dos segundos sube la temperatura 150 grados en uno de los reactores
   task body tskVariacionTemperatura is
      variance:aleatorioReactor;
      seed:RNG.Generator;
      tNextRelease: Time;
      tiReleaseInterval:constant Time_Span:=Milliseconds(2000);

   begin

      tNextRelease := Clock + tiReleaseInterval;
      loop
         RNG.Reset(seed);
         variance := RNG.Random(seed);

           if(variance = 1) then
               plant1.setOutput(plant1.getOutput+150);
           elsif(variance = 2) then
               plant2.setOutput(plant2.getOutput+150);

            else
               plant3.setOutput(plant3.getOutput+150);

           end if;

         delay until tNextRelease;
         tNextRelease := tNextRelease + tiReleaseInterval;
      end loop;

   end tskVariacionTemperatura;

   TemperaturaVariance: tskVariacionTemperatura;


   procedure getTotalOutput1(out1:out Output_t) is
      task type p1;
      task body p1 is
      begin
         out1 := plant1.getOutput;
         plant1.vivir1(1);
      end p1;

      taskp1:p1;
   begin
      null;
   exception
         when Constraint_Error => out1:=-1;
   end getTotalOutput1;

    procedure getTotalOutput2(out2:out Output_t) is
      task type p2;
      task body p2 is
      begin
         out2 := plant2.getOutput;
	plant2.vivir2(1);
      end p2;

      taskp2:p2;
   begin
      null;
      exception
         when Constraint_Error => out2:=-1;
   end getTotalOutput2;

    procedure getTotalOutput3(out3:out Output_t) is
      task type p3;
      task body p3 is
      begin
         out3 := plant3.getOutput;
         plant3.vivir3(1);
      end p3;

      taskp3:p3;
   begin
      null;
       exception
         when Constraint_Error => out3:=-1;
   end getTotalOutput3;


   task type tskMonitorTemperatura1;--tarea para MANDAR muestrear el valor de la temperatura de cada reactor cada 2 segundos(SensorLector)

   task body tskMonitorTemperatura1 is
      tNextRelease: Time;
      tiReleaseInterval:constant Time_Span:=Milliseconds(2000);

      out1:Output_t;
      vivo1:Integer:=0;
      type plant_ptr is access all Reactor_t;
      first:plant_ptr:=plant1'access;


   begin
      plant1.setID(1);

      tNextRelease := Clock + tiReleaseInterval;
      loop
         getTotalOutput1(out1);
         delay 0.1;

         if(out1 = -1) then
		abort tskMonitorTemperatura1;
         end if;

         first.estoyVivo1;
               if (out1>=1500 and out1<1750) then
           	 first.setOperation(-1);
               elsif(out1>=1750) then
              	 Put_Line("PELIGRO SUBIDA temperatura REACTOR 1:"&Integer'Image(out1));
               	 first.setOperation(1);
               else first.setOperation(0);
               end if;

         delay until tNextRelease;
         tNextRelease := tNextRelease + tiReleaseInterval;

      end loop;

   end tskMonitorTemperatura1;

   task type tskMonitorTemperatura2; --tarea para MANDAR muestrear el valor de la temperatura de cada reactor cada 2 segundos(SensorLector)

   task body tskMonitorTemperatura2 is
      tNextRelease: Time;
      tiReleaseInterval:constant Time_Span:=Milliseconds(2000);

      out2:Output_t;

      type plant_ptr is access all Reactor_t;

      second:plant_ptr:=plant2'Access;




   begin
      plant2.setID(2);
      tNextRelease := Clock + tiReleaseInterval;
      loop
         getTotalOutput2(out2);
         delay 0.1;

         if(out2 = -1) then
		abort tskMonitorTemperatura2;
         end if;

         second.estoyVivo2;

               if (out2>=1500 and out2<1750) then
           	 second.setOperation(-1);
               elsif(out2>=1750) then
              	 Put_Line("PELIGRO SUBIDA temperatura REACTOR 2:"&Integer'Image(out2));
               	 second.setOperation(1);
               else second.setOperation(0);
                  end if;

         delay until tNextRelease;
         tNextRelease := tNextRelease + tiReleaseInterval;
      end loop;

   end tskMonitorTemperatura2;

   task type tskMonitorTemperatura3; --tarea para MANDAR muestrear el valor de la temperatura de cada reactor cada 2 segundos(SensorLector)


   task body tskMonitorTemperatura3 is
      tNextRelease: Time;
      tiReleaseInterval:constant Time_Span:=Milliseconds(2000);

      out3:Output_t;

      type plant_ptr is access all Reactor_t;

      third:plant_ptr:=plant3'Access;

   begin
      plant3.setID(3);
      tNextRelease := Clock + tiReleaseInterval;
      loop
         getTotalOutput3(out3);
         delay 0.1;

         if(out3 = -1) then
		abort tskMonitorTemperatura3;
         end if;

         third.estoyVivo3;

               if (out3>=1500 and out3<1750) then
           	 third.setOperation(-1);
               elsif(out3>=1750) then
              	 Put_Line("PELIGRO SUBIDA temperatura REACTOR 3:"&Integer'Image(out3));
               	 third.setOperation(1);
               else third.setOperation(0);
               end if;

         delay until tNextRelease;
         tNextRelease := tNextRelease + tiReleaseInterval;
         --Aqui mandar mensaje a las tareas coordinadoras de cada reactor como que se esta vivo
      end loop;

   end tskMonitorTemperatura3;

   TemperaturaMonitoring1:tskMonitorTemperatura1;
   TemperaturaMonitoring2:tskMonitorTemperatura2;
   TemperaturaMonitoring3:tskMonitorTemperatura3;


begin
null;
end Main;

