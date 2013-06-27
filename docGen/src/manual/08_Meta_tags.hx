/**
@manual Meta tags in xml

There can be some tags in xml wich don't represent widgets. These are meta tags.
Their names must start with 'meta:' followed by the name of meta tag processor.
Meta processors are callbacks created to process specified meta tags and inject some
code in generated by StablexUI code. Full list of meta tags is available <a href="http://ui.stablex.ru/doc/#ru/stablex/ui/MetaTags.html">here</a>.
You can also create <a href="http://ui.stablex.ru/doc/#manual/09_Custom_meta_tags.html">custom tags</a>
*/


/**
@manual Meta: include

meta:include is used to include xml files in each other.
Let's say we have index.xml:

<xml>
<?xml version="1.0" encoding="UTF-8"?>

<Widget w="800" h="600"/>
    <!-- here goes meta -->
    <|meta:include src="someOther.xml" />
</Widget>
</xml>

and someOther.xml:

<xml>
<?xml version="1.0" encoding="UTF-8"?>

<Text text="'i am included!'" left="100" top="50"/>
</xml>

Using these two files is equal to using single file like this:

<xml>
<?xml version="1.0" encoding="UTF-8"?>

<Widget w="800" h="600"/>
    <Text text="'i am included!'" left="100" top="50"/>
</Widget>
</xml>

meta:include is useful if you need to reuse same parts for different UIs. It's also useful
if you want to divide one large xml file into several smaller to make it easier to maintain.
*/


/**
@manual Meta: inject

meta:inject is useful when you need to insert some custom haxe code:

<xml>
<?xml version="1.0" encoding="UTF-8"?>

<VBox w="800" h="600"/>
    <!-- here goes inject. E.g. you can define some vars here -->
    <|meta:inject code="
        var createdAt = $Lib.getTimer();
    " />

    <!-- now you can use this var -->
    <Button text="'Calculate life time!" on-click="
        #Text(label).text = 'I am ' + ($Lib.getTimer() - createdAt) + 'ms old';
    "/>
    <Text id="'label'" text="'I am ' + ($Lib.getTimer() - createdAt) + 'ms old'" />

</VBox>
</xml>

HINT:
It sounds strange, but sometimes flash and html5 targets does not call setters/getters
for properties of objects passed as arguments to <type>ru.stablex.ui.UIBuilder</type>.buildFn('ui.xml')({arguments}).
To workaround this problem, you need to explicity specify object's type. See following example:

<haxe>
class Test{
    //property with getter/setter
    public var intProp (get_intProp,never) : Int;
    private var _intProp : Int = 10;

    /**
    *   getter for intProp
    */
    private function get_intProp() : Int{
        return this._intProp;
    }

    //... rest of Test class ...


    /**
    *   Entry point
    */
    static public function main(){
        ru.stablex.ui.UIBuilder.UIBuilder.regClass('Test');
        flash.Lib.current.addChild( ru.stablex.ui.UIBuilder.buildFn('ui.xml')({
            test : new Test()
        }) );
    }
}//class Test
</haxe>

<xml>
<?xml version="1.0" encoding="UTF-8"?>

<Widget w="800" h="600">
    <!-- this is warkaround for html5 and flash -->
    <|meta:inject code="var test : $Test = cast(@test, $Test);"/>

    <!-- this button is expected to trace "10", but it will output "0" in flash -->
    <Button text="'fail trace'" on-click=" trace(@test.intProp); "/>

    <!-- this button traces "10" on all targets -->
    <Button text="'success trace'" on-click=" trace(test.intProp); "/>
</Widget>

</xml>
*/


/**
@manual Meta: repeat

meta:repeat brings the power of loops in xml. Content of this tag will be repeated
requested amount times.
meta:repeat has two attributes:
    * counter - variable to use for iterations count. Can be used in xml inside of meta:repeat;
    * times - amount of iterations. Any valid haxe code wich evaluates to <type>Int<type>.

<xml>
<?xml version="1.0" encoding="UTF-8"?>

<VBox w="300">
    <!-- repeat 10 times -->
    <meta:repeat counter="cnt" times="10">
        <Text text="'text' + cnt" widthPt="100" h="30" skin:Paint-color="cnt % 2 == 1 ? 0x555555 : 0xAAAAAA" align="'center,middle'"/>
    </meta:repeat>
</VBox>
</xml>

This xml is visually equal to

<xml>
<?xml version="1.0" encoding="UTF-8"?>

<VBox w="300">
    <Text text="'text0'" widthPt="100" h="30" skin:Paint-color="0xAAAAAA" align="'center,middle'"/>
    <Text text="'text1'" widthPt="100" h="30" skin:Paint-color="0x555555" align="'center,middle'"/>
    <Text text="'text2'" widthPt="100" h="30" skin:Paint-color="0xAAAAAA" align="'center,middle'"/>
    <Text text="'text3'" widthPt="100" h="30" skin:Paint-color="0x555555" align="'center,middle'"/>
    <Text text="'text4'" widthPt="100" h="30" skin:Paint-color="0xAAAAAA" align="'center,middle'"/>
    <Text text="'text5'" widthPt="100" h="30" skin:Paint-color="0x555555" align="'center,middle'"/>
    <Text text="'text6'" widthPt="100" h="30" skin:Paint-color="0xAAAAAA" align="'center,middle'"/>
    <Text text="'text7'" widthPt="100" h="30" skin:Paint-color="0x555555" align="'center,middle'"/>
    <Text text="'text8'" widthPt="100" h="30" skin:Paint-color="0xAAAAAA" align="'center,middle'"/>
    <Text text="'text9'" widthPt="100" h="30" skin:Paint-color="0x555555" align="'center,middle'"/>
</VBox>
</xml>

You can see result in <a href="http://ui.stablex.ru/demo/loops.swf" target="_blank">flash</a> or in <a href="http://ui.stablex.ru/demo/loops" target="_blank">html5</a>

*/