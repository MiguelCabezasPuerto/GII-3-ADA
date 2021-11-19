with Ada.Real_Time;
with Ada.Real_Time.Timing_Events;
with Ada.Text_IO;

use Ada.Real_Time;
use Ada.Real_Time.Timing_Events;
use Ada.Text_IO;

with Ada.Calendar.Formatting;

package ReactorNuclear is

   subtype Output_t is Integer range -1..3000;

   protected type Reactor_t is

      procedure setOperation(operation:in Integer);
      procedure Timer(event:in out Timing_Event);
      procedure Timeout(event:in out Timing_Event);
      function getOutput return Output_t;

      procedure setID(newID:in Integer);
      procedure setOutput(valor:in Integer);
      entry estoyVivo1;
      entry estoyVivo2;
      entry estoyVivo3;
      procedure vivir1(valor:in Integer);
      procedure vivir2(valor:in Integer);
      procedure vivir3(valor:in Integer);
   private

      tiTimeout:Time_Span:=Milliseconds(3000);
      tNextTime:Time;
      output:Output_t:= 1450;
      operation_mode:Integer:=0;
      tiEventPeriod:Time_Span:=Milliseconds(990);
      OutputEvent:Timing_Event;
      TimeoutEvent:Timing_Event;
      id:Integer;
      vivo1:Integer;
      vivo2:Integer;
      vivo3:Integer;

   end Reactor_t;

end ReactorNuclear;
