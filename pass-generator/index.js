const express = require('express');
const passkit = require('passkit-generator');
const fs = require('fs');

const app = express();
const port = 3000;

const password = () => {
    return 'Celmaibun2019';
}
app.use(express.json())

app.get('/generate-pass', async (_req, res) => {
    const p = await passkit.PKPass.from({
        model: './yonder-pass.pass',
        certificates: {
            wwdr: fs.readFileSync('./certificates/wwdr.pem'),
            signerCert: fs.readFileSync('./certificates/signerCert.pem'),
            signerKey: fs.readFileSync('./certificates/signerKey.pem'),
            signerKeyPassphrase: password()
        }
    })
    const buffer = p.getAsBuffer();
    fs.writeFileSync('./yy-pass.pkpass', buffer);

    res.sendFile(__dirname + '/yy-pass.pkpass');
});

app.post('/test', (req, res) => {
    res.json({ requestBody: req.body })
})

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
