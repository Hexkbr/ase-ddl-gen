set nocount on
go

select 'ddlgen'
   +' -U$1'                    -- user
   +' -P$2'                    -- password
   +' -S$3'                    -- server 
   +' -D$4'                    -- database name
   +' -Jutf8'                  -- server character set
   +' -T'+rtrim(type)          -- database object type
   +' -N'+name                 -- database object name 
   +' -O$4/table/'+name+'.sql' -- output file name
   +' -FTR,PC'        -- filter (skip triggers, partition condition) 
   +' && sed -i ''/print/,$!d'' $4/table/'               
         +name+'.sql' -- remove all lines until 'print'         
   +' && sed -i ''/use '+db_name()+'/,/go/d'' $4/table/' 
         +name+'.sql' -- remove 'use' statement
   +' && sed -i ''/\-\- DDLGen Completed/,/\-\- at/d'' $4/table/'    
         +name+'.sql' -- remove comments at the end of file
   +' && sed -i ''/with dml_/,/ on/d'' $4/table/'       
         +name+'.sql' -- remove DML logging option
   +' && sed -i ''/with exp_row_size/,/ on/d'' $4/table/'       
         +name+'.sql' -- remove DML logging option
   +' && sed -i ''/sp_placeobject/,/go/d'' $4/table/'   
         +name+'.sql' -- remove 'sp_placeobject' statement
   +' && sed -i s/'+db_name()+'\.//g $4/table/'         
         +name+'.sql' -- remove database name
 from sysobjects 
where type = 'U'
go
