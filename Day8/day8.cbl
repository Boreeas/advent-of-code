       >>SOURCE FORMAT IS FREE
*> *********************************************************************
*> Author:     Boreeas.
*> Date:       14/12/1995
*> Purpose:    I don't even know
*> Tectonics:  cobc -freea day8.cbl
*> *********************************************************************
identification division.
program-id. day8.

environment division.
configuration section.
input-output section.
file-control.
    select input-file
    assign to "input.txt"
    organization is line sequential
    file status is input-file-status
    .

data division.
file section.
fd input-file
    record is varying from 2 to 512 depending on line-length.
01 input-line.
    05 input-bytes PIC X occurs 512 times depending on line-length.


working-storage section.
01 line-length PIC 999 value 512.
01 input-file-status PIC 99.
01 string-code-length PIC 9999 value 0.
01 string-memory-length PIC 9999 value 0.
01 reencoded-length PIC 99999 value 0.
01 line-memory-accumulator PIC 999 value 0.
01 line-reencoded-memory-acc PIC 999 value 6.
01 result PIC 9999.
01 result2 PIC 9999.
01 i PIC 999.
01 escape-status PIC X(10) value "none".


procedure division.
open input input-file
if input-file-status greater than 9 then
   display
       "error: input.txt open failed with " input-file-status upon syserr
   end-display
   move 1 to return-code
   goback
end-if

perform until exit
    move 512 to line-length
    read input-file end-read
    if input-file-status greater than 10 then
        display
            "error during read: " input-file-status upon syserr
        end-display
        move 1 to return-code
        goback
    end-if

    if input-file-status equal to 10 then
        exit perform
    end-if

    add line-length to string-code-length giving string-code-length

    perform varying i from 2 by 1 until i equal to line-length
        if input-line(i:1) equal to '\' or input-line(i:1) equal to '"'
            add 2 to line-reencoded-memory-acc giving line-reencoded-memory-acc
        else
            add 1 to line-reencoded-memory-acc giving line-reencoded-memory-acc
        end-if

        if escape-status equal to "none"
            if input-line(i:1) equal to '\'
                move "in escape" to escape-status
            else
                add 1 to line-memory-accumulator giving line-memory-accumulator
            end-if

        else if escape-status equal to "in escape"
            if input-line(i:1) equal to 'x'
                move "hex escape" to escape-status
            else
                add 1 to line-memory-accumulator giving line-memory-accumulator
                move "none" to escape-status
            end-if

        else if escape-status equal to "hex escape"
            move "hexescape2" to escape-status

        else if escape-status equal to "hexescape2"
            move "none" to escape-status
            add 1 to line-memory-accumulator giving line-memory-accumulator
        end-if

    end-perform

    move "none" to escape-status
    add line-memory-accumulator to string-memory-length giving string-memory-length
    move 0 to line-memory-accumulator

    add line-reencoded-memory-acc to reencoded-length giving reencoded-length
    move 6 to line-reencoded-memory-acc
end-perform

subtract string-memory-length from string-code-length giving result
subtract string-code-length from reencoded-length giving result2

close input-file
display "Total string code length: " string-code-length end-display
display "Total string mem length : " string-memory-length end-display
display "Total reencoded length  : " reencoded-length end-display
display "Difference repr-mem: " result end-display
display "Difference repr-enc: " result2 end-display
goback.
end program day8.