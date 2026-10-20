<?php
/**
 * Sortuje liste wariantow alfabetycznie po polu `name` — wedlug zasad jezyka,
 * w ktorym klient oglada sklep.
 *
 * Rdzen podaje kolory w kolejnosci pozycji atrybutow (ag.position, a.position),
 * czyli w praktyce w kolejnosci dodawania do bazy. Przy 60–80 kolorach
 * multiproduktu nie da sie w tym nic znalezc, a pozycji w bazie nie warto
 * przestawiac: nazwy sa w 16 jezykach, wiec porzadek „alfabetyczny po polsku”
 * bylby przypadkowy po niemiecku, a kazdy nowy kolor i tak laduje na koncu.
 *
 * Collator (intl) zna polska kolejnosc (a, a, b, c, c… z ogonkami po literze
 * bazowej), nie patrzy na wielkosc liter („bordo wino” obok „Bordowy”) i z
 * NUMERIC_COLLATION stawia „2” przed „10”. Klucze tablicy zostaja — w
 * product-variants.tpl to id_attribute, na ktorym stoja radia i mapka numerow.
 * Rowne nazwy zachowuja kolejnosc z rdzenia.
 *
 *     {assign var=pickerAttributes value=$group.attributes|sort_by_name}
 *
 * @param array $items
 *
 * @return array
 */
function smarty_modifier_sort_by_name($items)
{
    if (!is_array($items) || count($items) < 2) {
        return $items;
    }

    static $collators = [];

    $language = Context::getContext()->language;
    $locale = str_replace('-', '_', (string) ($language->locale ?: $language->iso_code));

    if (!array_key_exists($locale, $collators)) {
        $collators[$locale] = null;
        if (class_exists('Collator')) {
            $collator = new Collator($locale);
            $collator->setAttribute(Collator::NUMERIC_COLLATION, Collator::ON);
            $collators[$locale] = $collator;
        }
    }
    $collator = $collators[$locale];

    $keys = array_keys($items);
    $names = [];
    foreach ($keys as $key) {
        $item = $items[$key];
        $names[] = (is_array($item) || $item instanceof ArrayAccess) && isset($item['name'])
            ? (string) $item['name']
            : '';
    }

    $order = array_keys($keys);
    usort($order, static function ($a, $b) use ($names, $collator) {
        $cmp = $collator
            ? (int) $collator->compare($names[$a], $names[$b])
            : strnatcasecmp($names[$a], $names[$b]);

        return $cmp ?: $a - $b;
    });

    $sorted = [];
    foreach ($order as $index) {
        $sorted[$keys[$index]] = $items[$keys[$index]];
    }

    return $sorted;
}
