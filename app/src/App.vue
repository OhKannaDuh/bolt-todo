<script setup lang="ts">
import Toolbar from "./components/Toolbar.vue";
import Content from "./components/Content.vue";

import BoltBrowser from "koala/BoltBrowser.ts";

const plugin = new BoltBrowser();

plugin.onmessage("config", function (data) {
  document.getElementById("app").style.zoom = data.window.app.scale;
});

window.addEventListener("DOMContentLoaded", () => {
  plugin.message("ready");
});
</script>

<template>
  <Toolbar :plugin="plugin" />
  <Content :plugin="plugin" />
</template>

<style scoped></style>
