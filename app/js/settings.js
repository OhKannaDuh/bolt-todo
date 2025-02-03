const { createApp, ref } = Vue;

const plugin = new BoltBrowser();
const app = createApp({
  data: () => {
    return {
      tasks: {
        daily: ref([]),
        weekly: ref([]),
        monthly: ref([]),
      },
      plugin: ref(plugin),
      input: {
        daily: ref(""),
        weekly: ref(""),
        monthly: ref(""),
      },
    };
  },
  methods: {
    add: (type) => {
      app.tasks[type].push({
        task: app.input[type].trim(),
        complete: false,
      });

      app.input[type] = "";

      plugin.message("update", app.tasks);
    },
    remove: (type, index) => {
      app.tasks[type].splice(index, 1);
      plugin.message("update", app.tasks);
    },
  },
}).mount("#app");

plugin.onmessage("tasks", function (data) {
  app.tasks.daily = ref(data.daily);
  app.tasks.weekly = ref(data.weekly);
  app.tasks.monthly = ref(data.monthly);
});

plugin.onmessage("config", function (data) {
  app.tasks.daily = ref(data.tasks.daily);
  app.tasks.weekly = ref(data.tasks.weekly);
  app.tasks.monthly = ref(data.tasks.monthly);
});

window.addEventListener("DOMContentLoaded", () => {
  plugin.message("ready");
});
