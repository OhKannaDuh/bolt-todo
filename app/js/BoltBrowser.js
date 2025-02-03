class BoltBrowser {
  message_callbacks = {};

  constructor() {
    window.addEventListener('message', (event) => {
      if (typeof event.data !== 'object' || event.data.type !== 'pluginMessage')
        return;

      let message = '';
      const bytes = new Uint8Array(event.data.content);
      for (let i = 0; i < bytes.byteLength; i++) {
        message += String.fromCharCode(bytes[i]);
      }

      message = JSON.parse(message)

      if (this.message_callbacks[message.type] === undefined) {
        console.warn(`Unhandled message type: ${message.type}`);
        return
      }

      for (const i in this.message_callbacks[message.type] ?? []) {
        this.message_callbacks[message.type][i](message.data);
      }
    });
  }

  onmessage(type, callback) {
    if (this.message_callbacks[type] === undefined) {
      this.message_callbacks[type] = []
    }

    this.message_callbacks[type].push(callback)
  }

  call(endpoint, data) {
    return fetch(endpoint, {method: 'POST', body: JSON.stringify(data ?? {})})
  }

  message(type, data) {
    return this.call('https://bolt-api/send-message', {type, data})
  }

  startreposition() {
    return this.call('https://bolt-api/start-reposition?h=0&v=0')
  }
}
