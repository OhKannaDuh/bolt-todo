<script setup lang="ts">
import BoltBrowser from "koala/BoltBrowser.ts";

const props = withDefaults(
  defineProps<{
    plugin: BoltBrowser;
    divet: Boolean;
    settings: Boolean;
  }>(),
  {
    divet: true,
    settings: true,
  }
);
</script>

<template>
  <div class="toolbar">
    <div
      v-if="divet"
      class="toolbar-divet"
      @mousedown.prevent="plugin.resize()"
    ></div>
    <div
      class="toolbar-main"
      :class="{ 'no-divet': !divet }"
      @mousedown.prevent="plugin.reposition()"
    ></div>
    <div
      v-if="settings"
      class="toolbar-settings"
      @click.prevent="plugin.message('settings')"
    ></div>
    <div class="toolbar-close" @click.prevent="plugin.close()"></div>
  </div>
</template>

<style scoped>
@import "rune-ui/toolbar.css";

.no-divet {
  border-left: 4px solid transparent;
}
</style>
