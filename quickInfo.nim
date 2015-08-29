import os,strutils,private
from memfiles import open, lines

##
##   Program     : quickInfo.nim
##
##   Status      : development
##
##   License     : MIT opensource
##
##   Version     : 0.2.0
##
##   ProjectStart: 2015-08-26
##
##   Compiler    : Nim 0.11.3
##
##   Description : proc,template,const etc. function lister 
##
##                 still needs work on indented blocks like:
##                 
##                 import
##                    blah1 ,blah2
##
##                
##                 compile:  nim cc -d:release --gc:markandsweep quickInfo
##                 
##                 run :  quickInfo somefile.nim      # uses reasonable defaults 
##                 
##                        quickInfo somefile.nim proc templat
##                 
##   Requires    : private.nim 
##   
##                 
##   Project     : https://github.com/qqtop/Nim-Snippets
##
##
##   Tested      : on linux only
##
##   Programming : qqTop
##
##   Note        : may be improved at any time
##


const QUICKINFOVERSION = 0.6 
const available = "Available : proc,template,converter,var,let,const,type,from,import"

 
proc showFunc*(fname: string,funcs: seq[string] = @["proc","template","converter","var","let","const","type","from","import"]) =
  superHeader("Info for : " & fname & $funcs,white,yellow)
  echo()
  var file = memfiles.open(fname, fmRead)
  for line in memfiles.lines(file):  
    
    let fields = line.fastsplit('\t')
    for funcy in funcs:
      
      var zl = fields[fields.low].strip()
      
      if zl.endswith("=") :
              delete(zl,zl.len -1 , zl.len)
              
      if zl.startswith(funcy):
               
        if funcy != "from" and funcy != "import":
           msgy() do : echo aline
        
        if zl.strip() == funcy:
           # this happens if we run into a block like
           # import
           #    blah1,blah2
           # 
           printColStr(black,funcy & "  block not shown")
          
        else:   
          printBiCol(zl,funcy & " ",brightyellow,green)              
        echo()  
      
      
    

proc main() =
  
  var cp = commandLineParams()
  var fc = newSeq[string]()
  # use self as default file 
  var afile = "quickInfo.nim"

  if cp.len > 0:
     afile = paramStr(1)
  
  if cp.len > 1:
     for x in 1.. <cp.len:
         fc.add(cp[x]) 
  
  if fc.len > 0:
    # this will show as specified on commandLine
    showFunc(afile,fc)
    
  else:
    # this would show all available 
    #showFunc(afile)
    
    # use a default with most used
    fc = @["proc","template","converter","from","import"]
    showFunc(afile,fc)
    echo()
    msgb() do : echo available
    
  echo()
  doFinish()

main()
