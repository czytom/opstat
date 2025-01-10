# OpStat

OpStat is an open-source system for collecting, processing, and visualizing server and component metrics.

## Overview

OpStat consists of three main modules:

1. **client**: Collects raw data and sends it to the master using a message queue (currently RabbitMQ).
2. **master**: Receives data from clients, processes it, and stores it in an InfluxDB database.
3. **plugins**: A repository of plugins for collecting and parsing data, used by both the client (plugins) and master (parsers).

The collected and processed data can be visualized using [Grafana](https://grafana.com/).

## Key Features

- Flexible data collection intervals: Each plugin can collect data at frequencies ranging from seconds to days.
- Modular architecture: Easily extendable with new plugins and parsers.
- Scalable: Designed to handle metrics from multiple servers and components.
- Integration with Grafana: Powerful visualization and alerting capabilities.

## Architecture

```
[Servers/Components] -> [Client + Plugins] -> [RabbitMQ] -> [Master + Parsers] -> [InfluxDB] -> [Grafana]
```

## Installation

(TO DO)

## Configuration

(TO DO)

## Usage

(TO DO)

## Contributing

We welcome contributions to OpStat! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.
( TO DO

## License

(TO DO)

## Contact

(TO DO)
