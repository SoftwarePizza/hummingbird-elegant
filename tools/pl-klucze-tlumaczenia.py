#!/usr/bin/env python3
"""Tłumaczenia kluczy motywu, których źródło jest po polsku (motyw dziedziczy je z izpola).
PrestaShop pokazuje źródło, gdy brak tłumaczenia — bez tych plików sklep DE/CZ/LT widzi polskie napisy.
Sklepy z tłumaczeniami w bazie (ps_translation, np. izpol) nie są dotknięte: baza ma pierwszeństwo.
Uruchomienie: python3 tools/pl-klucze-tlumaczenia.py  (dopisuje brakujące trans-unit do translations/<locale>/)."""
import hashlib, os, re, html
T = {  # domena: {źródło: (de, cs, lt)}
 'ShopThemeActions': {
  'Dodaj': ('Hinzufügen','Přidat','Pridėti'),
  'Zobacz koszyk': ('Warenkorb ansehen','Zobrazit košík','Peržiūrėti krepšelį'),
  'usuń': ('entfernen','odebrat','pašalinti'),
 },
 'ShopThemeCatalog': {
  'Darmowa dostawa od %amount%': ('Kostenloser Versand ab %amount%','Doprava zdarma od %amount%','Nemokamas pristatymas nuo %amount%'),
  'Długość': ('Länge','Délka','Ilgis'),
  'Kod produktu:': ('Artikelnummer:','Kód produktu:','Prekės kodas:'),
  'Najniższa cena z ostatnich 30 dni:': ('Niedrigster Preis der letzten 30 Tage:','Nejnižší cena za posledních 30 dní:','Mažiausia kaina per pastarąsias 30 dienų:'),
  'Ogólne parametry': ('Allgemeine Parameter','Obecné parametry','Bendrieji parametrai'),
  'Opis produktu': ('Produktbeschreibung','Popis produktu','Prekės aprašymas'),
  'Szczegóły produktu': ('Produktdetails','Podrobnosti o produktu','Prekės informacija'),
  'Szerokość': ('Breite','Šířka','Plotis'),
  'Wysokość': ('Höhe','Výška','Aukštis'),
  'Zapytaj o produkt': ('Frage zum Produkt','Zeptat se na produkt','Klausti apie prekę'),
  'zobacz pełny opis': ('vollständige Beschreibung anzeigen','zobrazit celý popis','rodyti visą aprašymą'),
  'zwiń opis': ('Beschreibung einklappen','sbalit popis','suskleisti aprašymą'),
 },
 'ShopThemeCheckout': {
  'Do darmowej dostawy brakuje Ci %amount%': ('Noch %amount% bis zum kostenlosen Versand','Do dopravy zdarma vám chybí %amount%','Iki nemokamo pristatymo trūksta %amount%'),
  'Masz darmową dostawę!': ('Ihre Lieferung ist kostenlos!','Máte dopravu zdarma!','Jums pristatymas nemokamas!'),
  'Twój koszyk': ('Ihr Warenkorb','Váš košík','Jūsų krepšelis'),
  'Twój koszyk jest pusty.': ('Ihr Warenkorb ist leer.','Váš košík je prázdný.','Jūsų krepšelis tuščias.'),
  'Wysyłka': ('Versand','Doprava','Pristatymas'),
 },
 'ShopThemeGlobal': {
  'Otrzymuj informacje o najnowszych produktach, promocjach i wydarzeniach.': ('Erhalten Sie Informationen zu neuen Produkten, Aktionen und Events.','Dostávejte informace o novinkách, akcích a událostech.','Gaukite informaciją apie naujausias prekes, akcijas ir renginius.'),
 },
}
LOC = [('de-DE','de'),('cs-CZ','cs'),('lt-LT','lt')]
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'translations')
for i,(loc,lang) in enumerate(LOC):
  for dom, pary in T.items():
    f = os.path.join(root, loc, f'{dom}.{loc}.xlf'); os.makedirs(os.path.dirname(f), exist_ok=True)
    tekst = open(f, encoding='utf-8').read() if os.path.exists(f) else (
      '<?xml version="1.0" encoding="UTF-8"?>\n<xliff xmlns="urn:oasis:names:tc:xliff:document:1.2" version="1.2">\n'
      f'  <file original="themes/hummingbird" source-language="pl" target-language="{lang}" datatype="plaintext">\n    <body>\n    </body>\n  </file>\n</xliff>\n')
    obecne = set(html.unescape(s) for s in re.findall(r'<source>(.*?)</source>', tekst, re.S))
    nowe = ''.join(
      f'      <trans-unit id="{hashlib.md5(src.encode()).hexdigest()}" approved="yes">\n'
      f'        <source>{html.escape(src, quote=False)}</source>\n        <target state="final">{html.escape(tr[i], quote=False)}</target>\n      </trans-unit>\n'
      for src, tr in pary.items() if src not in obecne)
    if nowe:
      # dopisz do pierwszego <body> (plik może mieć kilka <file>)
      tekst = tekst.replace('    </body>', nowe + '    </body>', 1)
      open(f, 'w', encoding='utf-8').write(tekst)
      print(f, nowe.count('<trans-unit'))
