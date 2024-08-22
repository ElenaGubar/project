﻿&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	РаботаСДокументами.ПолучитьСуммуСтроки(ТекДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	РаботаСДокументами.ПолучитьСуммуСтроки(ТекДанные);
КонецПроцедуры


&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
КонецПроцедуры           

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма");
КонецПроцедуры


//Цены номенклатуры           
&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	ТекущиеДанные.Цена = РаботаСоСправочниками.ЦенаНоменклатуры(Объект.Дата, ТекущиеДанные.Номенклатура);
	РаботаСДокументами.ПолучитьСуммуСтроки(ТекущиеДанные);
КонецПроцедуры



 





