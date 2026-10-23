#!/usr/bin/env python3
"""Descarga un paquete inicial de pictogramas de ARASAAC (CC BY-NC-SA).

Uso:  python tools/fetch_arasaac.py
Genera assets/pictograms/<id>.png y assets/pictograms.json.
Solo usa la biblioteca estándar. Es reanudable (salta lo ya descargado).
Pictogramas: ARASAAC (https://arasaac.org), Gobierno de Aragón, autor Sergio Palao.

Nota: "upa" se busca como "llevar en brazos" (ARASAAC 38713, un adulto con un bebé en la cadera).
"""
import json
import time
import unicodedata
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "pictograms"
SEARCH = "https://api.arasaac.org/v1/pictograms/es/search/{}"
IMAGE = "https://static.arasaac.org/pictograms/{0}/{0}_500.png"

COLORS = {
    "necesidades": "#CFE0EC", "comida": "#F2DDC4", "bebida": "#CDE6E3",
    "juegos": "#E3D6EC", "emociones": "#F2D5D9", "cuerpo": "#F0E3C6",
    "personas": "#D9E7CF", "acciones": "#DADDE6",
}

# categoría -> lista de (término de búsqueda, texto a decir; None = igual al término)
TERMS = {
    "necesidades": [
        ("agua", "quiero agua"), ("comer", "quiero comer"), ("jugar", "quiero jugar"),
        ("dolor", "me duele"), ("llevar en brazos", "upa"), ("más", "más"), ("terminar", "terminado"),
        ("baño", "quiero ir al baño"), ("dormir", "quiero dormir"), ("ayuda", "ayuda"),
        ("sí", "sí"), ("no", "no"), ("pañal", "pañal"), ("frío", "tengo frío"),
        ("calor", "tengo calor"), ("tengo hambre", "tengo hambre"), ("sed", "tengo sed"),
        ("cansado", "estoy cansado"), ("abrazo", "quiero un abrazo"), ("por favor", "por favor"),
        ("gracias", "gracias"), ("esperar", "esperar"), ("quiero", "quiero"), ("otra vez", "otra vez"),
    ],
    "comida": [
        ("pan", None), ("galleta", None), ("manzana", None), ("banana", None), ("naranja", None),
        ("pera", None), ("frutilla", None), ("uva", None), ("yogur", None), ("queso", None),
        ("huevo", None), ("carne", None), ("pollo", None), ("pescado", None), ("fideos", None),
        ("arroz", None), ("sopa", None), ("papa", None), ("zanahoria", None), ("tomate", None),
        ("ensalada", None), ("milanesa", None), ("pizza", None), ("helado", None), ("chocolate", None),
        ("torta", None), ("caramelo", None), ("cereales", None), ("tostada", None), ("jamón", None),
        ("desayuno", None), ("almuerzo", None), ("merienda", None), ("cena", None),
    ],
    "bebida": [
        ("leche", None), ("jugo", None), ("té", None), ("mate", None), ("gaseosa", None),
        ("vaso", None), ("botella", None), ("taza", None), ("mamadera", None), ("chupete", None),
    ],
    "juegos": [
        ("pelota", None), ("muñeca", None), ("autito", None), ("bloques", None), ("rompecabezas", None),
        ("dibujar", None), ("pintar", None), ("música", None), ("bailar", None), ("cantar", None),
        ("tele", None), ("tablet", None), ("cuento", None), ("libro", None), ("plaza", None),
        ("columpio", None), ("tobogán", None), ("burbujas", None), ("peluche", None), ("globo", None),
        ("plastilina", None), ("bicicleta", None), ("pileta", None), ("arena", None), ("instrumento", None),
        ("juguete", None), ("jugar a la pelota", None), ("cosquillas", None), ("tambor", None),
    ],
    "emociones": [
        ("contento", None), ("triste", None), ("enojado", None), ("asustado", None), ("enfermo", None),
        ("aburrido", None), ("sorprendido", None), ("tranquilo", None), ("nervioso", None),
        ("me gusta", None), ("no me gusta", None), ("amor", None), ("vergüenza", None), ("llorar", None),
        ("reír", None), ("preocupado", None), ("orgulloso", None),
    ],
    "cuerpo": [
        ("cabeza", None), ("panza", None), ("garganta", None), ("oído", None), ("diente", None),
        ("mano", None), ("pie", None), ("pierna", None), ("brazo", None), ("ojo", None),
        ("nariz", None), ("boca", None), ("espalda", None), ("fiebre", None), ("tos", None),
        ("vomitar", None), ("herida", None), ("médico", None), ("remedio", None), ("termómetro", None),
        ("lavarse las manos", None), ("lavarse los dientes", None), ("bañarse", None), ("peinarse", None),
    ],
    "personas": [
        ("mamá", None), ("papá", None), ("abuela", None), ("abuelo", None), ("hermano", None),
        ("hermana", None), ("tío", None), ("tía", None), ("primo", None), ("amigo", None),
        ("maestra", None), ("bebé", None), ("niño", None), ("niña", None), ("yo", None),
        ("vos", None), ("perro", None), ("gato", None), ("terapeuta", None), ("doctor", None),
    ],
    "acciones": [
        ("abrir", None), ("cerrar", None), ("dar", None), ("tomar", None), ("mirar", None),
        ("escuchar", None), ("caminar", None), ("correr", None), ("saltar", None), ("sentarse", None),
        ("pararse", None), ("salir", None), ("entrar", None), ("venir", None), ("ir", None),
        ("vestirse", None), ("ponerse los zapatos", None), ("cambiarse", None), ("limpiar", None),
        ("empujar", None), ("tirar", None), ("compartir", None), ("lavar", None), ("cortar", None),
        ("subir", None), ("bajar", None), ("parar", None), ("seguir", None), ("guardar", None),
        ("prender la luz", None), ("apagar", None), ("casa", None), ("auto", None), ("cama", None),
        ("silla", None), ("mesa", None), ("zapatos", None), ("campera", None), ("mochila", None),
    ],
}


def norm(s):
    return unicodedata.normalize("NFD", s).encode("ascii", "ignore").decode().lower()


def get(url, retries=3):
    for i in range(retries):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "pictograma-friendly/1.0"})
            with urllib.request.urlopen(req, timeout=30) as r:
                return r.read()
        except Exception:
            if i == retries - 1:
                return None
            time.sleep(1.5 * (i + 1))


def pick(term, results):
    """Prefiere pictogramas con la palabra exacta como keyword y aptos para CAA."""
    t = norm(term)

    def score(p):
        kws = [norm(k.get("keyword", "")) for k in p.get("keywords", [])]
        return (t in kws, kws[:1] == [t], bool(p.get("aac")), not p.get("violence"))

    return max(results, key=score)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    items, seen = [], set()
    for cat, terms in TERMS.items():
        for term, say in terms:
            raw = get(SEARCH.format(urllib.parse.quote(term)))
            try:
                results = json.loads(raw) if raw else []
            except json.JSONDecodeError:
                results = []
            if not results:
                print(f"  sin resultado: {term}")
                continue
            pid = pick(term, results)["_id"]
            if pid in seen:
                print(f"  repetido ({pid}): {term}")
                continue
            path = OUT / f"{pid}.png"
            if not path.exists():
                img = get(IMAGE.format(pid))
                if not img:
                    print(f"  fallo imagen: {term}")
                    continue
                path.write_bytes(img)
                time.sleep(0.15)
            seen.add(pid)
            items.append({
                "id": pid, "text": say or term, "category": cat,
                "color": COLORS[cat], "asset": f"assets/pictograms/{pid}.png",
            })
        print(f"[{cat}] acumulados: {len(items)}")
    (ROOT / "assets" / "pictograms.json").write_text(
        json.dumps({"source": "ARASAAC (CC BY-NC-SA) - Gobierno de Aragon, Sergio Palao",
                    "categories": COLORS, "pictograms": items}, ensure_ascii=False, indent=2),
        encoding="utf-8")
    print(f"Listo: {len(items)} pictogramas.")


if __name__ == "__main__":
    main()
