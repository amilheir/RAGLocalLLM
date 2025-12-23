Class Demo.Operations.Embedding.Response Extends (%Persistent, Ens.Response)
{

Property Vectors As %Stream.GlobalCharacter;

Property VectorsNumber As %Integer;

Storage Default
{
<Data name="ResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Vectors</Value>
</Value>
<Value name="3">
<Value>VectorsNumber</Value>
</Value>
</Data>
<DataLocation>^Demo.Operations.E34B7.ResponseD</DataLocation>
<DefaultData>ResponseDefaultData</DefaultData>
<IdLocation>^Demo.Operations.E34B7.ResponseD</IdLocation>
<IndexLocation>^Demo.Operations.E34B7.ResponseI</IndexLocation>
<StreamLocation>^Demo.Operations.E34B7.ResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
