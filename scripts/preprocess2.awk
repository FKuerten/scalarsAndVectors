#!/usr/bin/gawk --file

BEGIN {
    for (i = 1; i < ARGC; i++) {
        if(match(ARGV[i], /([a-zA-Z][a-zA-Z0-9]*)=([0-9]+)/, matches)) {
            variables[matches[1]]=matches[2]
            #print ARGV[i]
            #print matches[1], matches[2]
        }        
    }

    inBeginEndBlock = 0
    printing = 1
    swallow = 0
}

# The main functions

match($0, /^(.*)#\{([a-zA-Z_][a-zA-Z0-9_]*)\}(.*)$/, matches) {
    #print "found ------"
    #print matches[1]
    #print matches[2]
    #print matches[3]
    if (variables[matches[2]]) {
        print matches[1] variables[matches[2]] matches[3]
        next
    }
}

match($0, /^(.*)\(([0-9]+)(>|>=|<|<=|==|!=)([0-9]+)\)(.*)$/, matches) {
    #print matches[3]
    switch (matches[3]) {
        case ">=":
            result = (matches[2] >= matches[4])
            break
        default:
            exit 1
    }
    if (result) {
        print matches[1] "true" matches[5]
    } else {
        print matches[1] "false" matches[5]
    }
    next
}

match($0, /^#if true:(.*)$/, array) {
    #print "true"
    print array[1]
    next
}

match($0, /^#if false:(.*)$/, array) {
    #print "false"
    next
}

/^#if true begin$/ {    
    inBeginEndBlock++
    #print "in true, inBeginEndBlock=" inBeginEndBlock
    if (inBeginEndBlock==1) {
        swallow=1
        next
    }
}

/^#if false begin$/ {
    inBeginEndBlock++
    #print "in false, inBeginEndBlock=" inBeginEndBlock > "/dev/stderr"
    if (inBeginEndBlock==1) {
        printing=0
        swallow=1
        next
    }
}

match($0, /^#if (.*) begin$/, matches) {
    if (matches[1] != "true" && matches[1] != "false") {
        inBeginEndBlock++
        #print "in unknown, inBeginEndBlock=" inBeginEndBlock
    }
}

/^#end$/ {
    inBeginEndBlock--
    #print "exiting block, inBeginEndBlock=" inBeginEndBlock > "/dev/stderr"
    if (inBeginEndBlock==0) {    
        printing=1
        if (swallow) {
            swallow = 0
            next
        }        
    }
}


{
    if (printing) {
        print
        #print "\t\t" $0
    }
}
