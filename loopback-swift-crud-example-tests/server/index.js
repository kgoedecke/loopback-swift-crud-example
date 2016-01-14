var loopback = require('loopback');
var path = require('path');
var moment = require('moment');
var app = loopback();
app.set('legacyExplorer', false);
//app.use(loopback.logger(app.get('env') === 'development' ? 'dev' : 'default'));
app.dataSource('Memory', {
  connector: loopback.Memory,
  defaultForType: 'db'
});

var Widget = app.model('widget', {
  properties: {
    name: {
      type: String,
      required: true
    },
    bars: {
      type: Number,
      required: false
    },
    bars2: {
      type: Number,
      required: false
    },
    flag: {
      type: Boolean,
      required: false
    },
    updated: {
      type: Date,
      required: true
    }
  },
  dataSource: 'Memory'
});

Widget.observe('before save', function updateTimestamp(ctx, next) {
  if (ctx.instance) {
    console.log("New");
    ctx.instance.updated = new Date();
  } else {
    console.log("Update");
    var remoteDate = moment(ctx.currentInstance.updated);
    var reqDate = moment(ctx.data.updated);

    // If remote date is after request date drop the request
    if (remoteDate.isAfter(reqDate)) {
      console.log("Don't exec update");
      ctx.data = ctx.currentInstance;
    }

  }
  next(); 
});

var lbpn = require('loopback-component-push');
var PushModel = lbpn.createPushModel(app, { dataSource: app.dataSources.Memory });
var Installation = lbpn.Installation;
Installation.attachTo(app.dataSources.Memory);
app.model(Installation);

var ds = app.dataSource('storage', {
  connector: require('loopback-component-storage'),
  provider: 'filesystem',
  root: path.join(__dirname, 'storage')
});

var container = loopback.createModel({ name: 'container', base: 'Model' });
app.model(container, { dataSource: 'storage' });

Widget.destroyAll(function () {
  Widget.create({
    name: 'Foo',
    bars: 0,
    updated: '2018-01-02T03:04:05.006Z'
  });
  Widget.create({
    name: 'Bar',
    bars: 1,
    updated: '2017-01-02T03:04:05.006Z'
  });
});

app.model(loopback.AccessToken);

app.model('Customer', {
  options: {
    base: 'User',
    relations: {
      accessTokens: {
        model: "AccessToken",
        type: "hasMany",
        foreignKey: "userId"
      }
    }
  },
  dataSource: 'Memory'
});

app.dataSource('mail', { connector: 'mail', defaultForType: 'mail' });
loopback.autoAttach();

app.enableAuth();
app.use(loopback.token({ model: app.models.AccessToken }));
app.use(loopback.rest());
app.listen(3000, function() {
  console.log('https server is ready at https://localhost:3000.');
});
