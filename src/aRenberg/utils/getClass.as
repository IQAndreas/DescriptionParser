package aRenberg.utils
{
	public function getClass(target:*):Class
	{
		if (target is Class) { return target; }
		
		//Warning - The "constructor" getter may have been overriden!
		if (target.constructor is Class) { return target.constructor; }
		
		//Otherwise, put on the hard gloves! Ugh!
		import flash.utils.getQualifiedClassName;
		import flash.utils.getDefinitionByName;
		return getDefinitionByName(getQualifiedClassName(target)) as Class;
	}
}