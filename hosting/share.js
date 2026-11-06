// Clinician share page (phase 34). Draws the report document the app
// uploaded. Every string is set with textContent, never parsed as HTML.
//
// Page labels (phase 37) follow the report's language when the document
// names one, then the browser's languages, then English (the <template>
// in share.html). Add a language here when the app adds one.
(function () {
  "use strict";

  var STRINGS = {
    es: {
      title: "Informe de migraña compartido",
      loading: "Cargando el informe.",
      invalid: "Este enlace no está completo. Comprueba que se copió el enlace entero.",
      missing: "Este informe ya no se comparte. Quien lo compartió puede haber dejado de hacerlo.",
      expired: "Este enlace ha caducado.",
      error: "No se pudo cargar el informe. Inténtalo de nuevo en un momento.",
      until: "Compartido hasta el",
      readonly: "Copia de solo lectura compartida desde la app. Muestra un resumen del periodo, no el diario de la persona.",
    },
    pt: {
      title: "Relatório de enxaqueca compartilhado",
      loading: "Carregando o relatório.",
      invalid: "Este link está incompleto. Verifique se o link inteiro foi copiado.",
      missing: "Este relatório não está mais compartilhado. Quem o compartilhou pode ter parado de compartilhar.",
      expired: "Este link expirou.",
      error: "Não foi possível carregar o relatório. Tente de novo em instantes.",
      until: "Compartilhado até",
      readonly: "Cópia somente leitura compartilhada pelo app. Mostra um resumo do período, não o diário da pessoa.",
    },
    de: {
      title: "Geteilter Migränebericht",
      loading: "Bericht wird geladen.",
      invalid: "Dieser Link ist unvollständig. Prüfe, ob der ganze Link kopiert wurde.",
      missing: "Dieser Bericht wird nicht mehr geteilt. Die Person, die ihn geteilt hat, hat das Teilen möglicherweise beendet.",
      expired: "Dieser Link ist abgelaufen.",
      error: "Der Bericht konnte nicht geladen werden. Versuch es gleich noch einmal.",
      until: "Geteilt bis",
      readonly: "Schreibgeschützte Kopie aus der App. Sie zeigt eine Zusammenfassung des Zeitraums, nicht das Tagebuch der Person.",
    },
    fr: {
      title: "Rapport de migraine partagé",
      loading: "Chargement du rapport.",
      invalid: "Ce lien est incomplet. Vérifiez que le lien entier a été copié.",
      missing: "Ce rapport n'est plus partagé. La personne qui l'a partagé a peut-être arrêté le partage.",
      expired: "Ce lien a expiré.",
      error: "Impossible de charger le rapport. Réessayez dans un instant.",
      until: "Partagé jusqu'au",
      readonly: "Copie en lecture seule partagée depuis l'app. Elle montre un résumé de la période, pas le journal de la personne.",
    },
    hi: {
      title: "शेयर की गई माइग्रेन रिपोर्ट",
      loading: "रिपोर्ट लोड हो रही है।",
      invalid: "यह लिंक अधूरा है। जाँचें कि पूरा लिंक कॉपी हुआ है।",
      missing: "यह रिपोर्ट अब शेयर नहीं की जा रही। शेयर करने वाले व्यक्ति ने शायद शेयर करना बंद कर दिया है।",
      expired: "इस लिंक की समय-सीमा ख़त्म हो गई है।",
      error: "रिपोर्ट लोड नहीं हो सकी। थोड़ी देर में फिर कोशिश करें।",
      until: "इस तारीख़ तक शेयर:",
      readonly: "ऐप से शेयर की गई केवल पढ़ने वाली कॉपी। इसमें अवधि का सारांश है, व्यक्ति की डायरी नहीं।",
    },
    ja: {
      title: "共有された片頭痛レポート",
      loading: "レポートを読み込んでいます。",
      invalid: "このリンクは不完全です。リンク全体がコピーされているか確認してください。",
      missing: "このレポートは共有されていません。共有した人が共有を停止した可能性があります。",
      expired: "このリンクは期限切れです。",
      error: "レポートを読み込めませんでした。しばらくしてからもう一度お試しください。",
      until: "共有期限：",
      readonly: "アプリから共有された閲覧専用のコピーです。期間の要約を表示しており、本人の日記ではありません。",
    },
  };

  var root = document.getElementById("report");
  var messages = document.getElementById("messages").content;
  var lang = pickLanguage([]);

  /** The first supported primary language among [preferred], then the browser's. */
  function pickLanguage(preferred) {
    var candidates = preferred.concat(navigator.languages || [navigator.language || ""]);
    for (var i = 0; i < candidates.length; i++) {
      var code = String(candidates[i] || "").toLowerCase().split(/[-_]/)[0];
      if (code === "en" || STRINGS.hasOwnProperty(code)) return code;
    }
    return "en";
  }

  function setLanguage(code) {
    lang = code;
    document.documentElement.lang = code;
    if (lang !== "en") document.title = STRINGS[lang].title;
  }

  function message(key) {
    if (lang !== "en" && STRINGS[lang][key]) return STRINGS[lang][key];
    var node = messages.querySelector('[data-key="' + key + '"]');
    return node ? node.textContent : "";
  }

  function el(tag, className, text) {
    var node = document.createElement(tag);
    if (className) node.className = className;
    if (text !== undefined && text !== null) node.textContent = String(text);
    return node;
  }

  function show(key) {
    root.replaceChildren(el("p", "status", message(key)));
  }

  function table(header, rows) {
    var t = el("table");
    var head = el("thead");
    var tr = el("tr");
    header.forEach(function (h) {
      tr.appendChild(el("th", null, h));
    });
    head.appendChild(tr);
    t.appendChild(head);
    var body = el("tbody");
    rows.forEach(function (row) {
      var r = el("tr");
      row.forEach(function (cell) {
        r.appendChild(el("td", null, cell));
      });
      body.appendChild(r);
    });
    t.appendChild(body);
    var wrap = el("div", "table-wrap");
    wrap.appendChild(t);
    return wrap;
  }

  function calendar(block) {
    var box = el("section", "month");
    box.appendChild(el("h3", null, block.title));
    var grid = el("div", "grid");
    for (var i = 0; i < block.leading; i++) grid.appendChild(el("span", "day blank"));
    block.days.forEach(function (d) {
      var band = d.i == null || d.i <= 3 ? 0 : d.i <= 6 ? 1 : 2;
      var cls = "day" + (d.in ? "" : " out") + (d.a ? " attack band" + band : "");
      grid.appendChild(el("span", cls, d.a && d.i != null ? d.i : d.d));
    });
    box.appendChild(grid);
    return box;
  }

  function block(b) {
    switch (b.type) {
      case "heading":
        return el("h2", null, b.text);
      case "hint":
        return el("p", "hint", b.text);
      case "text":
        return el("p", null, b.text);
      case "stats": {
        var tiles = el("div", "tiles");
        b.tiles.forEach(function (t) {
          var tile = el("div", "tile");
          tile.appendChild(el("strong", null, t.value));
          tile.appendChild(el("span", null, t.label));
          tiles.appendChild(tile);
        });
        return tiles;
      }
      case "table":
        return table(b.header, b.rows);
      case "columns": {
        var cols = el("div", "columns");
        b.columns.forEach(function (lines) {
          var col = el("div");
          lines.forEach(function (line) {
            col.appendChild(el("p", null, line));
          });
          cols.appendChild(col);
        });
        return cols;
      }
      case "calendar":
        return calendar(b);
      default:
        return el("span");
    }
  }

  function render(data) {
    var d = data && data.document;
    if (!d || d.v !== 1 || !Array.isArray(d.blocks)) return show("error");
    if (typeof d.lang === "string") setLanguage(pickLanguage([d.lang]));
    document.title = d.title;
    var out = [el("h1", null, d.title), el("p", null, d.period), el("p", "hint", d.generated)];
    var until = new Date(data.expiresAt);
    out.push(el("p", "notice", message("readonly") + " " + message("until") + " " + until.toLocaleDateString(lang, { dateStyle: "medium" }) + "."));
    d.blocks.forEach(function (b) {
      out.push(block(b));
    });
    out.push(el("p", "disclaimer", d.disclaimer));
    out.push(el("footer", null, d.footer));
    root.replaceChildren.apply(root, out);
  }

  setLanguage(lang);
  document.getElementById("loading").textContent = message("loading");

  var token = location.pathname.split("/").filter(Boolean).pop() || "";
  if (!/^[A-Za-z0-9_-]{22}$/.test(token)) return show("invalid");

  fetch("/api/share/" + token, { cache: "no-store", credentials: "omit", referrerPolicy: "no-referrer" })
    .then(function (res) {
      if (res.status === 200) return res.json().then(render);
      return show(res.status === 410 ? "expired" : res.status === 404 ? "missing" : "error");
    })
    .catch(function () {
      show("error");
    });
})();
