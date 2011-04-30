package aRenberg.description
{
	import aRenberg.utils.getClass;
	
	import flash.utils.describeType;
	
	/**
	 * Keeps the "describeType" function separated off in case it is
	 * replaced with a more efficient way in the future.
	 * 
	 * This may also be a good place to cache results to save time.
	 */
	internal class DescriptionExtractor
	{
		
		/*
		public static function getDescriptionList(target:*, instanceMembers:Boolean, staticMembers:Boolean):XMLList
		{
			if (instanceMembers && staticMembers)
			{
				return DescriptionExtractor.getAllDescriptionList(getClass(target));
			}
			else if (instanceMembers)
			{
				return DescriptionExtractor.getInstanceDescriptionList(target);
			}
			else if (staticMembers)
			{
				return DescriptionExtractor.getStaticDescriptionList(getClass(target));
			}
			
			//else
			return new XMLList();
		}*/
		
		
		public static function getStaticDescriptionXML(target:Class):XML
		{
			var description:XML = describeType(target);
			delete description.factory;
			return description.*;
		}
		
		public static function getInstanceDescriptionXML(target:*):XML
		{
			var description:XML = describeType(target);
			if (target is Class)
			{
				//Since the "factory" tag doesn't have all the details,
				//fill it in with some info from the "type" tag.
				var factoryDescription:XML = description.factory;
				description.setChildren(factoryDescription.children()); //Sweet! A shortcut!
			}
			
			
			//return description.*; //Returns XMLList
			return description;		//Returns full XML (including "main" tag)
		}
		
		/* Deactivated as there needs to be some way to separate off the "factory" node
		 and merge it with the regular XML. It's easier keeping them separate for now.
		public static function getAllDescriptionList(target:*):XMLList
		{
			var description:XML = describeType(target);
			//return description.*; //Returns XMLList
			return description;		//Returns full XML (including "main" tag)
		} */
		
		
		
		public function DescriptionExtractor()
		{ /* Static class. Do not instantiate. */ }
		
	}
}