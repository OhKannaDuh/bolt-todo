<script setup lang="ts">
import Toolbar from "./components/Toolbar.vue";
import Settings from "./components/Settings.vue";

import BoltBrowser from "koala/BoltBrowser.ts";

const plugin = new BoltBrowser();

window.addEventListener("DOMContentLoaded", () => {
  plugin.message("ready");
});
</script>

<template>
  <Toolbar :plugin="plugin" :divet="false" :settings="false" />
  <Settings :plugin="plugin" />
</template>

<style scoped></style>
