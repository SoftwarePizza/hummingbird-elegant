<?php
/**
 * Adres jako poprawny URI w literale JSON — do blokow <script type="application/ld+json">.
 *
 * Sluggi produktow i kategorii trzymaja znaki narodowe (…/1007019-kostiuminė-vilna-…),
 * a szablon wypisuje adres tak, jak stoi w bazie: surowym UTF-8. Przegladarka
 * koduje takie znaki sama, gdy adres siedzi w href, ale wartosc w JSON-LD Google
 * bierze doslownie i zglasza w Search Console „Nieprawidlowy URL w polu id
 * (w itemListElement.item)”. Drugie zrodlo tego samego bledu to domyslny escape
 * HTML Smarty'ego, ktory przy dwoch parametrach w query robil z `&` encje `&amp;`
 * — w <script> nikt jej nie rozwija, wiec do Google szedl adres z „&amp;”.
 *
 * Kodujemy procentowo to, czego RFC 3986 w URI nie dopuszcza: bajty spoza
 * drukowalnego ASCII, spacje i garstke znakow (" < > \ ^ ` { } |). Gotowych
 * sekwencji %XX nie ruszamy, wiec modyfikator mozna zalozyc takze na adres juz
 * zakodowany. Zwracamy gotowy literal JSON, razem z cudzyslowami — w szablonie
 * stoi bez wlasnych cudzyslowow i z `nofilter`, bo escape HTML zepsulby wynik:
 *
 *     "item": {$path.url|jsonld_url nofilter}
 *
 * @param string $url
 *
 * @return string
 */
function smarty_modifier_jsonld_url($url)
{
    $encoded = preg_replace_callback(
        '/%(?![0-9A-Fa-f]{2})|[^\x21-\x7E]|["<>\\\\^`{}|]/',
        static function (array $match) {
            return rawurlencode($match[0]);
        },
        trim((string) $url)
    );

    return json_encode((string) $encoded, JSON_UNESCAPED_SLASHES);
}
