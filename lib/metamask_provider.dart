import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class MetaMaskProvider extends StatefulWidget {
  const MetaMaskProvider({super.key});

  @override
  _MetaMaskProviderState createState() => _MetaMaskProviderState();
}

class _MetaMaskProviderState extends State<MetaMaskProvider> {
  ReownAppKitModal? appKitModal;
  String walletAddress = 'No Address';
  String _balance = '0';

  @override
  void initState() {
    super.initState();
    initializeAppKitModal();
  }

  void initializeAppKitModal() async {
    appKitModal = ReownAppKitModal(
      context: context,
      projectId: '40e5897bd6b0d9d2b27b717ec50906c3',
      metadata: const PairingMetadata(
        name: 'Crypto Flutter',
        description: 'A Crypto Flutter Example App',
        url: 'https://www.reown.com/',
        icons: ['https://reown.com/reown-logo.png'],
        redirect: Redirect(
          native: 'cryptoflutter://',
          universal: 'https://reown.com',
          linkMode: true,
        ),
      ),
    );

    try {
      if (appKitModal != null) {
        debugPrint(
            'appKitModal is not null, proceeding with initialization...');

        await appKitModal!.init();
        debugPrint('appKitModal initialized successfully.');

        updateWalletAddress();
        debugPrint('updateWalletAddress() called successfully.');
      } else {
        debugPrint('appKitModal is null, skipping initialization.');
      }
    } catch (e) {
      debugPrint('Error caught during appKitModal initialization: $e');
    }

    appKitModal?.addListener(() {
      updateWalletAddress();
    });

    setState(() {});
  }

  void updateWalletAddress() {
    setState(() {
      if (appKitModal?.session != null) {
        walletAddress = appKitModal!.session!.address ?? 'No Address';
        _balance = appKitModal!.balanceNotifier.value;
      } else {
        walletAddress = 'No Address';
        _balance = '0';
      }
      debugPrint('Wallet address updated: $walletAddress');
      debugPrint('Balance updated: $_balance');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                expandedHeight: 230.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const SizedBox.shrink(),
                  background: Container(
                    color: const Color.fromARGB(255, 3, 169, 244),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'Payment',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Wallet Address: $walletAddress',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Balance: $_balance',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSimpleButton(
                            context,
                            appKitModal!.isConnected
                                ? 'Disconnect'
                                : 'Connect Wallet',
                            color: appKitModal!.isConnected
                                ? Colors.red
                                : Colors.green,
                            onPressed: () {
                              if (appKitModal!.isConnected) {
                                appKitModal!.disconnect();
                              } else {
                                appKitModal!.openModalView();
                              }
                            },
                          ),
                          _buildSimpleButton(
                            context,
                            'Send',
                            color: Colors.blue,
                            onPressed: () {
                              _showSendDialog(context);
                            },
                          ),
                          _buildSimpleButton(
                            context,
                            'Receive',
                            color: Colors.orange,
                            onPressed: () {
                              // Handle the receive button press
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Simplified Button Widget
  Widget _buildSimpleButton(BuildContext context, String text,
      {required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // Method to show the dialog for sending
  void _showSendDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recipient Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Recipient Address Starts with (0x..)'),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter recipient address',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
