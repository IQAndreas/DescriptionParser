package aRenberg.utils
{
	//Ignore case as well?
	public function strBoolean(string:String):Boolean
	{
		if (string == 'true')
		{ return true; }
		else if (string == 'false')
		{ return false; }
		
		//else - will return false if emtpy string or null
		return Boolean(string); 
		
		//Or return plain old false instead?
	}
}