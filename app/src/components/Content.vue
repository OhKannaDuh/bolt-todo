<script setup lang="ts">
import BoltBrowser from "koala/BoltBrowser";

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

type Tab = {
  key: keyof Tasks;
  label: string;
  show: boolean;
};

const tasks = ref<Tasks>({
  daily: [],
  weekly: [],
  monthly: [],
});

const tabs = ref<Tab[]>([
  {
    key: "daily",
    label: "Daily",
    show: true,
  },
  {
    key: "weekly",
    label: "Weekly",
    show: false,
  },
  {
    key: "monthly",
    label: "Monthly",
    show: false,
  },
]);

const count_complete = (key: keyof Tasks) => {
  let count = 0;

  for (const task of tasks.value[key]) {
    if (task.complete) {
      count++;
    }
  }

  return count;
};

const show = (tab: Tab) => {
  for (const data of tabs.value) {
    data.show = false;

    if (data.key === tab.key) {
      data.show = true;
    }
  }
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
});
</script>

<template>
  <div class="content">
    <div class="tabs">
      <button
        v-for="tab in tabs"
        :key="tab.key"
        class="tablinks button"
        :class="{ active: tab.show }"
        @click="show(tab)"
      >
        {{ tab.label }}
        <span v-if="tasks[tab.key]"
          >({{ count_complete(tab.key) }}/{{ tasks[tab.key].length }})</span
        >
      </button>
    </div>
    <div
      v-for="tab in tabs"
      :key="tab.key"
      class="scroll-area rune-scroll"
      :class="{ hidden: !tab.show }"
    >
      <ul>
        <li
          v-for="(task, index) in tasks[tab.key]"
          :key="index"
          class="task panel"
        >
          <span>{{ task.task }} </span>
          <div class="spacer"></div>
          <div class="checkbox-container">
            <div
              class="checkbox"
              :class="{ active: task.complete }"
              @click.prevent="
                {
                  task.complete = !task.complete;
                  plugin.message('tasks', tasks);
                }
              "
            ></div>
          </div>
        </li>
      </ul>
      <div
        v-if="!tasks[tab.key].length"
        class="text-center"
        style="padding: 8px"
      >
        No tasks in category ({{ tab.label }}), configure using the settings cog
        above.
      </div>
    </div>
  </div>
</template>

<style scoped>
@import "rune-ui/content.css";
@import "rune-ui/button.css";
@import "rune-ui/scroll.css";

.tabs {
  width: 100%;
  display: flex;
}

.tablinks {
  width: 100%;
}

.scroll-area {
  overflow-y: scroll;
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
  max-height: calc(100vh - 12px);
}

.button {
  flex-grow: 1;
  margin: 2px;
  color: #aed0e0;
}

.hidden {
  display: none;
}

.checkbox-container {
  display: flex;
  flex-direction: column;
  justify-content: start;
  width: 12px;
  width: 12px;
}

.checkbox {
  border: 2px solid transparent;
  border-image: url("rune-ui/assets/button-border.png") 2;
  height: 12px;
  width: 12px;
}

.checkbox.active {
  background-color: #aed0e0;
}
</style>
