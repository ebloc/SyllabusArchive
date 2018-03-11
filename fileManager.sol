pragma solidity ^0.4.0;
/*
contract Mapper{
    mapping(string => uint) public files;

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}
*/

contract FileManager{
   struct File{
       string fileHash;
       address issuer;
   }
   
   mapping (string => File ) files;
   string [] fileNames;
   
   function setFile(string fName, string fHash) public{
       var File = files[fName];
       fileNames.push(fName);
       File.fileHash = fHash;
       File.issuer = msg.sender;
       
       
   }
   
   function getFileHash(string fName) view public returns (string){
       if(bytes(files[fName].fileHash).length == 0){
           for(uint i=0; i<fileNames.length; i++){
               if(indexOf(fileNames[i],fName)!= -1){
                   return files[fileNames[i]].fileHash;
               }
           }
           return "not found";
       }
            
       else
            return files[fName].fileHash;
   }
   
   function getFileIssuer(string fName) view public returns (address){
      return files[fName].issuer;
   }
   
   
   function substring(string str, uint startIndex, uint endIndex) constant returns (string) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(endIndex-startIndex);
    for(uint i = startIndex; i < endIndex; i++) {
        result[i-startIndex] = strBytes[i];
    }
    return string(result);
}
    
     function compare(string _a, string _b) returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }

     
    
    function equal(string _a, string _b) returns (bool) {
        return compare(_a, _b) == 0;
    }
   
    function indexOf(string mainString, string subString) view public returns (int)
    {
    	bytes memory h = bytes(mainString);
    	bytes memory n = bytes(subString);
    	if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
    		return -1;
    	else if(h.length > (2**128 -1)) 
    		return -1;									
    	else
    	{
    		uint subindex = 0;
    		for (uint i = 0; i < h.length; i ++)
    		{
    			if (h[i] == n[0])
    			{
    				subindex = 1;
    				while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) 
    				{
    					subindex++;
    				}	
    				if(subindex == n.length){
    					return int(i);
    				}
    			}
    		}
    		return -1;
    	}	
    }
    
  
   
   
}
