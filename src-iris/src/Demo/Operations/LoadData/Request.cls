Class Demo.Operations.LoadData.Request Extends (%Persistent, Ens.Request)
{

Property Pdf As %Integer;

Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Pdf</Value>
</Value>
</Data>
<DataLocation>^Demo.Operations.LoFBA5.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<IdLocation>^Demo.Operations.LoFBA5.RequestD</IdLocation>
<IndexLocation>^Demo.Operations.LoFBA5.RequestI</IndexLocation>
<StreamLocation>^Demo.Operations.LoFBA5.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
