package aRenberg.description
{
	import aRenberg.description.common.DescriptorType;
	import aRenberg.description.d.DMember;
	import aRenberg.description.d.Description;
	import aRenberg.description.metadata.IMetadata;
	import aRenberg.description.metadata.MetadataUtils;

	/** 
	 * Only parses instances, NOT classes as of right now, since if you want to
	 * add functions like "getValue" and "setValue", they will not work with Classes,
	 * but require actual instances. 
	 */ 
	public class DescriptionParser
	{

		
		/*public function parseClass(object:Class, includeStatic:Boolean = false):Description
		{
			return this.parse(object, true, includeStatic);
		}*/
		
		public static function parseObject(object:*):Description
		{
			if (object is Class)
			{
				//Ignore the properties of the instance it creates.
				//Only parse out the metadata found in the actual static class properties.
				return DescriptionParser.parse(object, false, true);
			}
			else
			{
				return DescriptionParser.parse(object, true, false);
			}
		}
		
		private static function parse(target:*, instanceMembers:Boolean = true, staticMembers:Boolean = false):Description
		{
			if (!target) { return null; }
			
			var descriptionXML:XML;
			//Cannot do both as of right now!
			if (instanceMembers) 	{ descriptionXML = DescriptionExtractor.getInstanceDescriptionXML(target) }
			else if (staticMembers) { descriptionXML = DescriptionExtractor.getStaticDescriptionXML(target) }
			else 					{ descriptionXML = new XML(); }
			
			return DescriptionUtils.descriptionFromXML(target, descriptionXML);
		}
		
		
		
		public function DescriptionParser()
		{ /* Static class. Do not instantiate. */ }
		
	}
}