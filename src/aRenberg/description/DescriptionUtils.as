package aRenberg.description
{

	import aRenberg.description.common.AccessType;
	import aRenberg.description.common.DescriptorType;
	
	import aRenberg.description.d.DAccessor;
	import aRenberg.description.d.DConstant;
	import aRenberg.description.d.DMember;
	import aRenberg.description.d.DMethod;
	import aRenberg.description.d.DMethodParameter;
	import aRenberg.description.d.DVariable;
	import aRenberg.description.d.Description;
	
	import aRenberg.description.metadata.IMetadata;
	import aRenberg.description.metadata.Metadata;
	import aRenberg.description.metadata.MetadataUtils;
	
	import aRenberg.utils.strBoolean;

	public class DescriptionUtils
	{
		
		/**
		 * Target is only used so generated DMember instances can 
		 * reference it. It is not used in the actual parsing here.
		 */ 
		public static function descriptionFromXML(target:*, targetXML:XML):Description
		{
			var targetClass:String = String( targetXML.attribute( 'name' ));
			var baseClass:String = 	 String( targetXML.attribute( 'baseClass' ));
			
			var isDynamic:Boolean = strBoolean( targetXML.attribute( 'isDynamic' ));
			var isFinal:Boolean = 	strBoolean( targetXML.attribute( 'isFinal' ));
			var isStatic:Boolean = 	strBoolean( targetXML.attribute( 'isStatic' ));
			
			var members:Vector.<DMember> =     DescriptionUtils.getMembers(target, targetXML);
			var metadatas:Vector.<IMetadata> = DescriptionUtils.getTargetMetadata(targetXML);
			
			return new Description(target, targetClass, baseClass, isDynamic, isFinal, isStatic, members, metadatas);
		}
			
		private static function getMembers(target:*, descriptionXML:XML):Vector.<DMember>
		{
			var memberList:XMLList = descriptionXML.*;
			var members:Vector.<DMember> = new Vector.<DMember>();
						
			for each (var memberXML:XML in memberList)
			{
				var member:DMember = DescriptionUtils.memberFromXML(target, memberXML);
				if (member) 
				{ 
					members.push(member);
				}
				else
				{
					//If it's not a member, perhaps it is metadata or other XML
					//Ignore it for now.
				}
			}
			
			return members;
		}
		
		
		/**
		 * Will return the metadata of ONLY the target, not of "sub targets".
		 * IE: If you pass in a Class, it will only return the class metadata,
		 * not the metadata of the class members.
		 * 
		 * Since the Metadata class (and the IMetadata interface) does not need a "target",
		 * there is no need to pass it into the function. The Metadata class instead uses
		 * properties "name" and "targetName" rather than actual references.
		 */ 
		private static function getTargetMetadata(targetXML:XML):Vector.<IMetadata>
		{
			var metadataList:XMLList = targetXML.metadata;
			var metadatas:Vector.<IMetadata> = new Vector.<IMetadata>();
			
			for each (var metadataXML:XML in metadataList)
			{
				var metadata:IMetadata = MetadataUtils.parse(metadataXML);
				if (metadata) { metadatas.push(metadata); }
				else		  { /* Ignore the bad XML. Perhaps throw a warning? */ }
			}
			
			//Will return empty Vector rather than null if nothing is found.
			return metadatas;
		}

		
		private static function memberFromXML(target:*, memberXML:XML):DMember
		{
			switch (String(memberXML.name()))
			{
				case DescriptorType.ACCESSOR : 	return accessorFromXML(target, memberXML);
				case DescriptorType.METHOD   : 	return methodFromXML(target, memberXML);
				case DescriptorType.VARIABLE : 	return variableFromXML(target, memberXML);
				case DescriptorType.CONSTANT :	return constantFromXML(target, memberXML);
			}
			
			//else
			return null;
		}
		
		
		private static function accessorFromXML(target:*, memberXML:XML):DAccessor
		{
			var name:String = String( memberXML.attribute( 'name' ));
			var type:String = String( memberXML.attribute( 'type' ));
			var declaredBy:String = String( memberXML.attribute( 'declaredBy' ));
			
			var access:String = String( memberXML.attribute( AccessType.NAME ));
			var isReadable:Boolean = AccessType.canRead(access);
			var isWriteable:Boolean = AccessType.canWrite(access);
			
			var metadata:Vector.<IMetadata> = DescriptionUtils.getTargetMetadata(memberXML);
			
			return new DAccessor(target, name, type, isReadable, isWriteable, declaredBy, metadata);
		}
		
		private static function methodFromXML(target:*, memberXML:XML):DMethod
		{
			var name:String = String( memberXML.attribute( 'name' ));
			var type:String = String( memberXML.attribute( 'returnType' ));
			var declaredBy:String = String( memberXML.attribute( 'declaredBy' ));
			
			var parameters:Vector.<DMethodParameter> = new Vector.<DMethodParameter>();
			var parametersList:XMLList = memberXML.parameter; //Should be an XMLList I hope!
			for each (var parameterXML:XML in parametersList)
			{
				parameters.push( methodParameterFromXML(parameterXML) );
			}
			
			var metadata:Vector.<IMetadata> = DescriptionUtils.getTargetMetadata(memberXML);
			
			return new DMethod(target, name, type, declaredBy, parameters, metadata);
		}
		
		private static function methodParameterFromXML( parameterXML:XML ):DMethodParameter
		{
			var index:uint = uint( parameterXML.attribute( 'index' ));
			var type:String = String( parameterXML.attribute( 'type' ));
			var optional:Boolean = strBoolean( parameterXML.attribute( 'optional' ));
			return new DMethodParameter(index, type, optional);
		}
		
		private static function variableFromXML(target:*, memberXML:XML):DVariable
		{
			var name:String = String( memberXML.attribute( 'name' ));
			var type:String = String( memberXML.attribute( 'type' ));
			
			var metadata:Vector.<IMetadata> = DescriptionUtils.getTargetMetadata(memberXML);
			
			return new DVariable(target, name, type, metadata);
		}
		
		private static function constantFromXML(target:*, memberXML:XML):DConstant
		{
			var name:String = String( memberXML.attribute( 'name' ));
			var type:String = String( memberXML.attribute( 'type' ));
			
			var metadata:Vector.<IMetadata> = DescriptionUtils.getTargetMetadata(memberXML);
			
			return new DConstant(target, name, type, metadata);
		}
		
		
		public function DescriptionUtils()
		{ /* Static class. Do not instantiate. */ }
		
	}
}