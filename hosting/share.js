// Clinician share page (phase 34). Draws the report document the app
// uploaded. Every string is set with textContent, never parsed as HTML.
(function () {
  "use strict";

  var root = document.getElementById("report");
  var messages = document.getElementById("messages").content;

  function message(key) {
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
    document.title = d.title;
    var out = [el("h1", null, d.title), el("p", null, d.period), el("p", "hint", d.generated)];
    var until = new Date(data.expiresAt);
    out.push(el("p", "notice", message("readonly") + " " + message("until") + " " + until.toLocaleDateString(undefined, { dateStyle: "medium" }) + "."));
    d.blocks.forEach(function (b) {
      out.push(block(b));
    });
    out.push(el("p", "disclaimer", d.disclaimer));
    out.push(el("footer", null, d.footer));
    root.replaceChildren.apply(root, out);
  }

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
