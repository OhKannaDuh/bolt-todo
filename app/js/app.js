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
      height: ref(0),
      tabs: ref([
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
      ]),
    };
  },
  methods: {
    count_complete: function (key) {
      let count = 0;

      for (const task of this.tasks[key]) {
        if (task.value) {
          count++;
        }
      }

      return count;
    },

    show: function (tab) {
      for (const data of this.tabs) {
        data.show = false;

        if (data.key === tab.key) {
          data.show = true;
        }
      }
    },
  },
}).mount("#app");

plugin.onmessage("tasks", function (data) {
  app.tasks.daily = ref(data.daily);
  app.tasks.weekly = ref(data.weekly);
  app.tasks.monthly = ref(data.monthly);
});

plugin.onmessage("config", function (data) {
  app.height.value = data.window.height;
  app.tasks.daily = ref(data.tasks.daily);
  app.tasks.weekly = ref(data.tasks.weekly);
  app.tasks.monthly = ref(data.tasks.monthly);
});

window.addEventListener("DOMContentLoaded", () => {
  plugin.message("ready");
});
