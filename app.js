const express = require('express');
const fs = require('fs');

// Create an Express app
const app = express();

// Load firewall rules from rules.json
const firewallRules = JSON.parse(fs.readFileSync('rules.json'));

// Middleware function to check firewall rules
app.use((req, res, next) => {
    const clientIP = req.socket.remoteAddress.replace(/^.*:/, '');  // Get client IP
    const clientPort = req.socket.remotePort;                       // Get client port

    // Check if the IP is blocked
    if (firewallRules.blockedIPs.includes(clientIP)) {
        return res.status(403).send('Access Denied: Your IP is blocked by the firewall.\n');
    }

    // Check if the IP is allowed
    if (!firewallRules.allowedIPs.includes(clientIP)) {
        return res.status(403).send('Access Denied: Your IP is not allowed.\n');
    }

    // Check if the port is allowed
    if (!firewallRules.allowedPorts.includes(clientPort)) {
        return res.status(403).send('Access Denied: The port you are using is blocked.\n');
    }

    // If all checks pass, allow the request
    next();
});

// Simple route for testing the firewall
app.get('/', (req, res) => {
    res.send('Welcome, you have passed the firewall!');
});

// Start the Express server
const port = 8080;
app.listen(port, () => {
    console.log(`Firewall running on http://localhost:${port}`);
});
