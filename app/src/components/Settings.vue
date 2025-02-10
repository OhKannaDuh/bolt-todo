<script setup lang="ts">
import BoltBrowser from "koala/BoltBrowser.ts";

const props = defineProps<{
  plugin: BoltBrowser;
}>();

import { ref } from "vue";

type Task = {
  task: string;
  complete: boolean;
};

type Tasks = {
  daily: Task[];
  weekly: Task[];
  monthly: Task[];
};

type Input = {
  daily: String;
  weekly: String;
  monthly: String;
};

const scale = ref(1);

const tasks = ref<Tasks>({
  daily: [],
  weekly: [],
  monthly: [],
});

const input = ref<Input>({
  daily: "",
  weekly: "",
  monthly: "",
});

const add = (type: keyof Tasks & keyof Input) => {
  console.log(type, input.value[type].trim());
  tasks.value[type].push({
    task: input.value[type].trim(),
    complete: false,
  });

  input.value[type] = "";
  props.plugin.message("update", tasks.value);
};

const remove = (type: keyof Tasks & keyof Input, index: number) => {
  tasks.value[type].splice(index, 1);
  props.plugin.message("update", tasks.value);
};

const title = (title: string): string => {
  return String(title).charAt(0).toUpperCase() + String(title).slice(1);
};

props.plugin.onmessage("tasks", function (data) {
  tasks.value.daily = data.daily;
  tasks.value.weekly = data.weekly;
  tasks.value.monthly = data.monthly;
});

props.plugin.onmessage("config", function (data) {
  tasks.value.daily = data.tasks.daily;
  tasks.value.weekly = data.tasks.weekly;
  tasks.value.monthly = data.tasks.monthly;
  scale.value = data.window.app.scale;
});
</script>

<template>
  <div class="content">
    <div class="note panel">
      <p>Why has this opened in a seperate window?</p>
      <p>
        Due to current limitations with bolt, keyboard is not captured by
        embedded windows.
      </p>
    </div>

    <div class="panel">
      Plugin Window Scale:
      <input
        type="number"
        @change.prevent="plugin.message('update-scale', { scale })"
        v-model="scale"
      />
      <br />
      <sub>Useful for high resolution monitors</sub>
    </div>

    <div class="panel main" v-for="key in ['daily', 'weekly', 'monthly']">
      <h2 class="title">{{ title(key) }} Tasks</h2>
      <ul>
        <li v-for="(task, index) in tasks[key]" :key="index" class="task panel">
          <span>{{ task.task }} </span>
          <div class="spacer"></div>

          <div class="remove-container">
            <div class="button remove" @click.prevent="remove(key, index)">
              <svg
                width="12px"
                height="12px"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M6 6L18 18M18 6L6 18"
                  stroke="#f4e85c"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
            </div>
          </div>
        </li>
      </ul>
      <p v-if="!tasks[key].length" class="panel">No {{ key }} tasks set</p>
      <div class="panel add">
        <input
          v-model="input[key]"
          :placeholder="`Add new ${key} task`"
          v-on:keyup.enter="add(key)"
        />
        <button @click="add(key)">Add</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import "rune-ui/content.css";
@import "rune-ui/button.css";

.title {
  margin: 0 4px 0 0;
}

.note p {
  margin: 0 0 4px;
}

.main.panel {
  margin-top: 12px;
}

.tabs {
  width: 100%;
  display: flex;
}

.tablinks {
  width: 100%;
}

.task {
  display: flex;
  padding: 2px 8px;
}

.spacer {
  flex-grow: 1;
}

ul {
  padding: 0;
  margin: 0;
}

.content {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.button {
  flex-grow: 1;
  margin: 2px;
  color: #aed0e0;
  background-size: cover;
}

.remove-container {
  display: flex;
  flex-direction: column;
  justify-content: start;
  width: 16px;
  min-width: 16px;
}

.remove {
  border: 2px solid transparent;
  border-image: url("rune-ui/assets/button-border.png") 2;
  height: 16px;
  width: 16px;
  max-height: 16px;
  max-width: 16px;
  background-image: none;
  background-color: #630b05;
  color: #f4e85c;
}

.remove:hover {
  background-image: none;
  background-color: #a91d12;
  color: #f4e85c;
}

.add {
  display: flex;
  padding: 4px;
}

.add input {
  flex-grow: 1;
}
</style>
