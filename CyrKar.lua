   function decoding(s)
     local r, b = ''
     for i = 1, s and s:len() or 0 do
           b = s:byte(i)
--           r = r..b..'_'
          if b < 128 then
            r = r..string.char(b)
          elseif b >= 208 then  
            r = r..string.char(b)..string.char(s:byte(i+1))
            i = i + 1
          elseif b == 195 then
             if s:byte(i+1) <= 175 then
              r = r..string.char(208)..string.char(s:byte(i+1)+16)
              i = i + 1
             else 
              r = r..string.char(209)..string.char(s:byte(i+1)-48)
              i = i + 1
             end
          end
     end
     return r
   end
  

  cur_editor = reaper.MIDIEditor_GetActive()
  cur_take = reaper.MIDIEditor_GetTake(cur_editor)
  reaper.Undo_OnStateChange("Change CP1252 -> UTF-8 TextEvents")
  NotesCnt, __, __, TxtCnt = reaper.MIDI_CountEvts(cur_take)

  --reaper.MIDI_SelectAll(cur_take, false)
   
   
--   ccrv,ccsel,ccmute,ccppq,ccmsg,ccchan,ccmsg2,ccmsg3 = reaper.MIDI_GetEvt(cur_take, 28,true,true,1,'Text')
        reaper.ShowConsoleMsg('')
 
   for ii = 0, TxtCnt - 1 do
   retval1,txt1,txt2,txt3,txt4,txt5 = reaper.MIDI_GetTextSysexEvt( cur_take, ii)
   
--    if retval then
     if txt4 == 1 then txt4 = 5 end
     reaper.MIDI_SetTextSysexEvt( cur_take, ii,txt1,txt2,txt3,txt4,decoding(txt5))
--        reaper.ShowConsoleMsg(txt5..' - originale\n')
--    end 
   end
  reaper.Undo_OnStateChange("Change CP1252 -> UTF-8 TextEvents")   
